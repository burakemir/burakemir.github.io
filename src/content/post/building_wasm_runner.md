+++
title = "Building a Wasm Runner with Cloud Hypervisor"
date = 2025-12-16
[taxonomies]
categories = ["blog"]
tags = ["rust", "wasm", "cloud-hypervisor", "virtualization"]
[extra]
math = false
+++

In this post, I will demonstrate how to run WebAssembly (Wasm) inside a MicroVM. I'll provide context first, then focus on a few selected implementation details.

## Wasm for Extensibility

Architecture defines what parts of a system are stable and what parts are dynamic. System extensions are a prime example of dynamic components, but they raise significant security and observability concerns—especially when the code is untrusted.

Consider this scenario:

* I need to run user-provided code.
* I do not trust this code.
* The system must load, execute, and potentially unload the code at runtime without build dependencies.
* It must be efficient.
* It must support user-friendly debugging.

This mirrors the challenges faced by cloud providers and security-conscious platform engineers.

WebAssembly (Wasm) is an excellent fit for this because:

* Many languages compile to Wasm.
* Wasm is designed for a specific execution environment (the runtime).
* The runtime is extensible.

The Wasm runtime allows running user code that interacts with the "outside" through a well-defined interface. Note that "runtime" here is synonymous with "execution environment" or "virtual machine" (like the JVM).

In summary, Wasm allows us to run code while the runtime manages the API and isolation. Problem solved? Not quite.

## Sandboxing the Sandbox

The isolation provided by a Wasm runtime reduces the privileges of user code (sandboxing), but risks remain:

* The Wasm runtime itself may have vulnerabilities.
* The API exposed to user code might inadvertently allow unsafe access to the operating system.

Wasm acts as a security boundary, but mistakes are possible. Two levels of isolation provide significantly better security.

In this post, we will set up a "MicroVM" to execute Wasm payloads. We will build a minimal Function-as-a-Service (FaaS) runtime from scratch using Rust, [Cloud Hypervisor](https://github.com/cloud-hypervisor/cloud-hypervisor), and Wasmtime. This setup will boot a Linux kernel, load a WebAssembly module over a virtual socket, and execute it.

If you are familiar with Microsoft's [Hyperlight-Wasm](https://github.com/hyperlight-dev/hyperlight-wasm), this approach is similar but focuses on the fundamentals.

To follow along, you need a Linux machine with KVM enabled and the ability to configure and build a Linux kernel. If you are using a cloud VPS, ensure nested virtualization is enabled.

Unlike many minimal tutorials that use static linking (musl), we will use a dynamically linked C runtime. This allows us to use the standard system unwinder (glibc), providing full panic stack traces inside the VM—crucial for debugging failing user code.

### The Architecture

Cloud Hypervisor is a virtual machine monitor (VMM) written in Rust, descending from the CrosVM and Firecracker family. It simulates hardware abstractions rather than executing high-level language instructions.

We will simulate a machine that boots a minimal Linux kernel, which then executes the Wasm runtime as its *only* process.

We will use "Direct Kernel Boot" with the following components:

*   **The Hypervisor:** Cloud Hypervisor (built in Rust, runs on top of KVM).
*   **The Guest Kernel:** A minimal Linux kernel (`vmlinux`).
*   **The Guest OS:** A custom Initramfs containing our Rust binary and necessary shared libraries (`libc.so`, `libgcc`, etc.).
*   **The Payload:** A Wasm module that performs pure computation.
*   **The Transport:** VirtIO-VSOCK, providing a direct pipe between host and guest.

### Step 1: The Minimal Kernel

Cloud Hypervisor works best with a kernel tuned for PVH booting (skipping legacy BIOS/UEFI).

Follow instructions on [Cloud Hypervisor docs](https://github.com/cloud-hypervisor/cloud-hypervisor?tab=readme-ov-file#building-your-kernel) or
build the kernel your own way using `make menuconfig`. Ensure the following are set to **Yes** (not Module):

*   `CONFIG_PVH=y`: For fast booting.
*   `CONFIG_VIRTIO_PCI=y`: To see virtual hardware.
*   `CONFIG_VIRTIO_VSOCKETS=y`: For communication.
*   `CONFIG_BLK_DEV_INITRD=y`: To load the custom binary.

### Step 2: The Wasm Payload

We need code to run. We’ll compile this Rust function to `wasm32-unknown-unknown` to keep it "pure"—no system calls, just math and memory.

**wasm_payload/src/lib.rs**

```rust
// A 1MB static buffer inside the Wasm linear memory
const BUF_SIZE: usize = 1024 * 1024;
static mut BUFFER: [u8; BUF_SIZE] = [0; BUF_SIZE];

#[unsafe(no_mangle)]
#[allow(static_mut_refs)]
pub extern "C" fn get_buffer_ptr() -> *mut u8 {
    unsafe { BUFFER.as_mut_ptr() }
}

#[unsafe(no_mangle)]
pub extern "C" fn process_data(len: usize) -> usize {
    let slice = unsafe { &mut BUFFER[0..len] };
    
    // Example: Reverse the bytes
    slice.reverse();
    
    // Return the length processed
    len
}
```

Compile it:

```bash
cargo build --target wasm32-unknown-unknown --release
```

If you have not compiled to Wasm before, you may want to run `rustup target add wasm32-unknown-unknown`.

### Step 3: The Guest "Init" (The Micro-OS)

We will write a Rust program that acts as the entire guest operating system. It boots, listens on a socket, runs Wasm, and shuts down. Interaction happens via system calls, mediated by the C runtime library.

We use a Dual-Socket design:
*   **Port 1000 (Control):** Metadata, Wasm binary uploads, status signals.
*   **Port 1001 (Data):** Raw data stream.

This allows streaming data directly from the socket into the Wasm memory buffer. Zero-copy isn't possible here because we must copy data into the Wasm module instance's memory to maintain isolation.

**guest_init/src/main.rs**

```rust
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio_vsock::VsockListener;
use wasmtime::*;

const CMD_PORT: u32 = 1000;
const DATA_PORT: u32 = 1001;

#[tokio::main]
async fn main() {
    println!("[Guest] Booting Dual-Socket Runner...");

    // 1. Setup Wasm Engine
    let mut config = Config::new();
    config.async_support(true);
    let engine = Engine::new(&config).unwrap();
    let linker = Linker::new(&engine);
    let mut store = Store::new(&engine, ());

    // 2. Start Listeners
    let mut cmd_listener = VsockListener::bind(u32::MAX, CMD_PORT).expect("Bind CMD failed");
    let mut data_listener = VsockListener::bind(u32::MAX, DATA_PORT).expect("Bind DATA failed");
    
    println!("[Guest] Waiting for Host to connect...");

    // 3. Accept Connections (Sequential for simplicity)
    // Host must connect to CMD first, then DATA.
    let (mut cmd_stream, _) = cmd_listener.accept().await.unwrap();
    println!("[Guest] CMD connected.");
    
    let (mut data_stream, _) = data_listener.accept().await.unwrap();
    println!("[Guest] DATA connected.");

    // 4. Receive Wasm Binary (over CMD channel for reliability)
    let mut size_buf = [0u8; 4];
    cmd_stream.read_exact(&mut size_buf).await.unwrap();
    let wasm_len = u32::from_be_bytes(size_buf) as usize;
    println!("[Guest] Downloading Wasm module ({} bytes)...", wasm_len);

    let mut wasm_binary = vec![0u8; wasm_len];
    cmd_stream.read_exact(&mut wasm_binary).await.unwrap();

    // 5. Instantiate
    let module = Module::new(&engine, &wasm_binary).unwrap();
    let instance = linker.instantiate_async(&mut store, &module).await.unwrap();
    
    let memory = instance.get_memory(&mut store, "memory").expect("No memory exported");
    let get_ptr = instance.get_typed_func::<(), i32>(&mut store, "get_buffer_ptr").unwrap();
    let process_func = instance.get_typed_func::<i32, i32>(&mut store, "process_data").unwrap();
    
    let wasm_ptr = get_ptr.call_async(&mut store, ()).await.unwrap() as usize;

    println!("[Guest] Wasm Ready. Entering Processing Loop.");
    let _ = cmd_stream.write_all(b"READY").await; // Signal Host

    // 6. Processing Loop
    loop {
        // A. Wait for Command: "Process X bytes"
        let mut job_header = [0u8; 4];
        if cmd_stream.read_exact(&mut job_header).await.is_err() { break; }
        let data_len = u32::from_be_bytes(job_header) as usize;
        eprintln!("Expecting Payload len {data_len}!");

        // B. READ DIRECTLY TO WASM MEMORY
        // We get a mutable slice of Wasm memory.
        let mem_data = memory.data_mut(&mut store);
        // Safety check bounds
        if wasm_ptr + data_len > mem_data.len() {
            eprintln!("Payload too big for Wasm buffer!");
            break;
        }
        let wasm_slice = &mut mem_data[wasm_ptr .. wasm_ptr + data_len];
        
        // This is the key step: Kernel copies socket buffer -> Wasm Memory directly.
        data_stream.read_exact(wasm_slice).await.unwrap();

        eprintln!("Read data!!");
        // C. EXECUTE
        process_func.call_async(&mut store, data_len as i32).await.unwrap();
        eprintln!("Made call!!");

        // D. WRITE DIRECTLY FROM WASM MEMORY
        let mem_data = memory.data(&store); // Re-borrow immutable
        let result_slice = &mem_data[wasm_ptr .. wasm_ptr + data_len];

        eprintln!("Writing result!!");
        data_stream.write_all(result_slice).await.unwrap();
        
        eprintln!("Writing done!!");
        // E. Ack
        let _ = cmd_stream.write_all(b"DONE").await;
    }
}

```

### Why we use Dynamic Linking

Many tutorials suggest compiling with `x86_64-unknown-linux-musl` to get a single static binary. While this is small (5MB), it breaks the ability to get stack traces because the musl unwinder often conflicts with JIT compilers like Wasmtime.

Instead, we compile normally which on Linux will link dynamically against glibc. We then bundle the shared libraries and ship them into the VM.

```bash
cargo build --release 
```

We use a script to automatically find the required `.so` files (`libc.so.6`, `libgcc_s.so.1`, etc.) and package them into the initramfs.
Please note that my cargo outputs binaries into `/tmp`, you may need to adjust the paths to the binary.

**package_vm.sh**

```bash
#!/bin/bash
set -e

APP_NAME="guest_init"
BIN_PATH="/tmp/target/release/$APP_NAME"
BUILD_DIR="./build_output"

# 1. Clean and Create Staging Area
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/lib64
mkdir -p $BUILD_DIR/lib/x86_64-linux-gnu

# 2. Copy the Main Binary to /init
echo "Copying binary..."
cp $BIN_PATH $BUILD_DIR/init

# 3. Find and Copy Shared Libraries
echo "Resolving dependencies..."

# Get list of dependencies using ldd
# Output format is usually: "libname.so => /path/to/libname.so (address)"
DEPENDENCIES=$(ldd $BIN_PATH | awk '{if ($3 != "") print $3; else print $1}')

for DEP in $DEPENDENCIES; do
    # Skip virtual dynamically linked things like linux-vdso.so.1
    if [[ "$DEP" == *"vdso"* ]]; then
        continue
    fi

    # Check if file exists
    if [ -f "$DEP" ]; then
        echo "  Bundling: $DEP"

        # We need to copy it to the SAME path structure relative to root
        # e.g., /lib/x86_64-linux-gnu/libc.so.6 -> build_output/lib/x86_64-linux-gnu/libc.so.6

        DIRname=$(dirname "$DEP")
        mkdir -p "$BUILD_DIR$DIRname"
        cp "$DEP" "$BUILD_DIR$DEP"
    else
        echo "  Warning: Could not find $DEP"
    fi
done

# 4. Handle the Dynamic Linker explicitly
# ldd output often shows the loader as a full path, but we need to ensure
# the interpreter path hardcoded in the binary exists.
INTERPRETER=$(readelf -l $BIN_PATH | grep "interpreter" | awk -F': ' '{print $2}' | tr -d ']')
echo "  Bundling Interpreter: $INTERPRETER"
if [ -f "$INTERPRETER" ]; then
    DIRname=$(dirname "$INTERPRETER")
    mkdir -p "$BUILD_DIR$DIRname"
    cp "$INTERPRETER" "$BUILD_DIR$INTERPRETER"
fi

# 5. Create CPIO
echo "Creating initramfs.cpio..."
cd $BUILD_DIR
find . -print0 | cpio --null -ov --format=newc > ../initramfs.cpio
cd ..

echo "Done! Dynamic initramfs ready."
```

This increases the image size to ~25MB, but in return, if our Rust code panics or Wasmtime crashes, we get a full, readable stack trace in the console.

### Step 4: The Host Driver

We implement the host driver in Rust to orchestrate the VM. It connects to the Cloud Hypervisor via the Unix domain socket `/tmp/ch_vsock.sock`.

**The "Connect String" Mechanism**

Cloud Hypervisor uses a Unix domain socket on the host to expose the VSOCK capability. It acts as a bridge. However, unlike a direct socket connection where you just connect and talk, Cloud Hypervisor acts as a multiplexer.

When we connect to the Unix socket, we are talking to the Hypervisor, not the guest yet. We must tell the Hypervisor which *guest port* we want to reach. We do this by sending a text command:

`CONNECT <PORT>\n`

If the connection is successful, Cloud Hypervisor will respond with:

`OK <PORT>\n`

Only *after* receiving this acknowledgement can we start sending raw binary data intended for the guest. If we skip this, our data will be interpreted as commands by the Hypervisor, causing errors.

**host_runner/src/main.rs**

```rust
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::UnixStream;
use std::time::Duration;

const SOCKET_PATH: &str = "/tmp/ch_vsock.sock";
const CMD_PORT: u32 = 1000;
const DATA_PORT: u32 = 1001;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("[Host] Connecting to Guest via {}...", SOCKET_PATH);

    // 1. Connect to Guest (Retry loop until Guest is up)
    let mut cmd_stream = connect_via_unix(SOCKET_PATH, CMD_PORT).await?;
    let mut data_stream = connect_via_unix(SOCKET_PATH, DATA_PORT).await?;

    // 2. Read Wasm Binary
    let wasm_path = "target/wasm32-unknown-unknown/release/payload.wasm";
    let wasm_binary = std::fs::read(wasm_path).expect("Failed to read Wasm file");
    let wasm_len = wasm_binary.len() as u32;

    // 3. Send Wasm Binary
    println!("[Host] Sending Wasm binary...");
    cmd_stream.write_all(&wasm_len.to_be_bytes()).await?;
    cmd_stream.write_all(&wasm_binary).await?;
    
    // 4. Wait for Ready Signal from Guest
    let mut buf = [0u8; 5]; // "READY"
    cmd_stream.read_exact(&mut buf).await?;
    assert_eq!(&buf, b"READY");
    println!("[Host] Guest is READY.");

    // 5. Send Data Job
    let payload = b"Hello MicroVM!";
    let payload_len = payload.len() as u32;
    cmd_stream.write_all(&payload_len.to_be_bytes()).await?;
    data_stream.write_all(payload).await?;

    // 6. Receive Result
    let mut result_buf = vec![0u8; payload_len as usize];
    data_stream.read_exact(&mut result_buf).await?;
    println!("[Host] Result: {:?}", String::from_utf8_lossy(&result_buf));

    Ok(())
}

async fn connect_via_unix(path: &str, port: u32) -> Result<UnixStream, Box<dyn std::error::Error>> {
    loop {
        match UnixStream::connect(path).await {
            Ok(mut stream) => {
                // Handshake for Cloud Hypervisor
                let msg = format!("CONNECT {}\n", port);
                stream.write_all(msg.as_bytes()).await?;
                
                // Read Response: "OK <port>\n"
                let mut resp = String::new();
                loop {
                    let mut b = [0u8; 1];
                    stream.read_exact(&mut b).await?;
                    let c = b[0] as char;
                    resp.push(c);
                    if c == '\n' { break; }
                }
                
                if !resp.starts_with("OK") {
                     return Err(format!("Handshake failed: {}", resp.trim()).into());
                }
                return Ok(stream);
            },
            Err(_) => {
                // Wait for Cloud Hypervisor to create the socket
                tokio::time::sleep(Duration::from_millis(500)).await;
            }
        }
    }
}
```

### Step 5: Launch!

We invoke Cloud Hypervisor, pointing it to our kernel, our CPIO (initramfs), and enabling the VSOCK device.

```bash
sudo ./cloud-hypervisor \
    --kernel ./vmlinux \
    --cmdline "console=hvc0 quiet" \
    --initramfs ./initramfs.cpio \
    --vsock cid=3,socket=/tmp/ch_vsock.sock
```

In a separate terminal, run the Host Runner:

```bash
cargo run --release --bin host_runner
```

### Summary

We just built a secure, isolated runtime where:

*   **Isolation:** The code runs in a VM, not a container. The kernel enforces the boundary.
*   **Observability:** By shipping glibc, we have full debugging capabilities inside the guest.
*   **Speed:** By stripping the OS to the bare essentials and using VSOCK, overhead is minimal.

There is a lot more here that can be done, like using virtiofs to expose selected files on the
host to the guest, tuning the kernel to optimize boot time, or system programming interface,
all the way to implementing hypercalls.

This architecture is the foundation of modern high-density serverless platforms. You now have the blueprint to build your own.

