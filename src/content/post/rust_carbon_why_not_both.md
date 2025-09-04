+++
title = "Rust and Carbon, why not both"
date = 2025-08-27
[taxonomies]
categories = ["blog"]
tags = ["rust", "carbon", "c++"]
[extra]
math = true
+++

Today's post is a little different. Instead of delving into discussiong of formal type systems, I'd like to step back and talk generally about some aspects of linear type systems 
as they show up in real life. That means: programming languages and the memory safety discussion today, C++ and Rust. Disclaimer: while the content of this post is very much 
related to memory safety which is something I work on at Google, this is my personal blog and everything here is my personal opinion.

In programming, managing memory and resources is one of the most critical and error-prone tasks. Getting it wrong can lead to nasty bugs, from crashes to security vulnerabilities. Two languages that take this challenge seriously, but with vastly different philosophies, are C++ and Rust.

At the heart of this difference lies how their type systems handle the concepts of **copying** and **moving** data. While both languages have syntax for these operations, Rust's type system acts as a strict guardian, preventing common errors at compile time, whereas C++ offers more flexibility at the cost of placing the burden of safety squarely on the developer.

### The C++ Way: A Set of Powerful Conventions

In C++, the ability for an object to be copied or moved is defined by a set of special member functions. If you've written any C++, you've likely encountered the **"Rule of Five"**:

*   **Copy Constructor:** `MyType(const MyType& other);`
*   **Copy Assignment Operator:** `MyType& operator=(const MyType& other);`
*   **Move Constructor:** `MyType(MyType&& other);`
*   **Move Assignment Operator:** `MyType& operator=(MyType&& other);`
*   **Destructor:** `~MyType();`

When you create a type that manages a resource, like a memory buffer, you implement these functions to define what it means to copy or move it. A copy usually involves a "deep copy"—allocating new memory and copying the data over. A move is an optimization that "steals" the internal resource from a temporary object, avoiding a costly allocation.

Let's look at a classic example: a simple string-like class.


```C++
#include <cstring>
#include <iostream>

class NaiveString {
public:
    NaiveString(const char\* s) {
        std::cout << "Allocating memory for '" << s << "'\n";
        size = std::strlen(s) + 1;
        data = new char[size];
        std::memcpy(data, s, size);
    }

    // Move constructor: "steals" the pointer
    NaiveString(NaiveString&& other) noexcept
        : data(other.data), size(other.size) {
        std::cout << "Moving from '" << (other.data ? other.data : "") << "'\n";
        // Invalidate the source object!
        other.data = nullptr;
        other.size = 0;
    }

    ~NaiveString() {
        if (data) {
            std::cout << "Freeing memory for '" << data << "'\n";
        } else {
            std::cout << "Destructing a moved-from object\n";
        }
        delete[] data;
    }

    char* data;
    size_t size;
};

int main() {
    NaiveString s1("hello");
    std::cout << "s1.data = " << (void\*)s1.data << "\n";

    // Move s1 into s2
    NaiveString s2 = std::move(s1);
    std::cout << "s2.data = " << (void\*)s2.data << "\n";

    // What about s1 now?
    std::cout << "s1.data after move = " << (void\*)s1.data << "\n";

    // This is the danger zone! C++ lets you do this.
    // Accessing s1.data here is undefined behavior.
    // if (s1.data) {
    //     std::cout << "s1 still contains: " << s1.data << "\n"; // CRASH!
    // }

    return 0;
}
```


The problem here isn't the move itself; it's what happens _after_. The C++ type system doesn't stop you from trying to use s1 after its resources have been moved to s2. The s1 object is left in a "valid but unspecified state." Accessing it is a landmine waiting to be stepped on. **The compiler trusts you not to mess up**, but offers no guarantee.


### The Rust Way: A Contract with the Compiler

Rust builds memory safety directly into its type system through three core principles:



1. Each value has a single **owner**.
2. There can only be **one owner at a time**.
3. When the owner goes out of scope, the value is **dropped** (i.e., its resources are freed).

In Rust, **moving is the default behavior** for any type that manages resources. When you assign a variable to another, ownership is transferred.


```Rust
fn main() {
    // String owns heap-allocated memory
    let s1 = String::from("hello");

    // Ownership of the data is MOVED from s1 to s2.
    // s1 is now considered uninitialized.
    let s2 = s1;

    // This line will not compile! 
    // The compiler prevents a "use after move" error.
    // println!("The value of s1 is: {}", s1); 
    //                                      ^^ value borrowed here after move

    println!("The value of s2 is: {}", s2);
}
```

This is the crucial difference. The Rust compiler _tracks ownership_. It knows that s1 is no longer valid after the move and turns a potential runtime bug into a **compile-time error**. It's not a convention; it's a hard-and-fast rule enforced by the type system.


#### So, How Do You Copy in Rust?

What if you have data that is simple, lives entirely on the stack (like an integer), and is cheap to copy? For this, Rust has the Copy trait.

A type is Copy if making a bit-for-bit copy of it is a complete and valid clone. Think of types like i32, f64, bool, or a struct containing only other Copy types.

When you assign a Copy type, the original variable remains valid.


```Rust
fn main() {
    // i32 implements the Copy trait
    let x = 5;

    // A copy is made. Both x and y are valid.
    let y = x;

    println!("x = {}, y = {}", x, y); // This works perfectly!
}
```

The compiler enforces a critical rule: **you cannot implement Copy for a type that manages a resource**. For example, String cannot be Copy because it owns a pointer to heap memory. If you could copy a String, you'd have two variables pointing to the same memory, leading to a "double free" error when both go out of scope. The compiler forbids this, neatly closing another door to memory corruption.


### The Philosophical Divide 🧐

The difference boils down to two philosophies:

|C++|Rust|
|---|----|
|<strong>Trusts the Developer:</strong> Provides powerful tools (move semantics) and trusts the programmer to use them correctly. Safety is a matter of discipline and convention (e.g., not using an object after moving from it). |<strong>Verifies with the Compiler:</strong> Bakes ownership and moving directly into the type system. The compiler <em>guarantees</em> at compile time that you cannot use a moved value or accidentally create multiple owners of the same resource.|
|<strong>Opt-out Safety:</strong> By default, types can be copied or moved if the syntax is valid. The developer must explicitly delete functions (e.g., = delete;) to make a type non-copyable or non-movable.|<strong>Opt-in Simplicity:</strong> Moving is the default for complex types. Simple, bit-wise copying is an opt-in behavior via the Copy trait, which the compiler validates to ensure it's used safely.|
|<strong>Runtime Errors:</strong> Mistakes like use-after-move or double-frees manifest as crashes or undefined behavior at runtime, which can be difficult to debug.|<strong>Compile-time Errors:</strong> The same mistakes are caught by the compiler before the program can even run, providing clear, actionable feedback.|

### Under the Hood: A Glimpse into Rust's Type Theory

So how does the Rust compiler pull this off? It's not magic; it's the practical application of ideas from programming language research, specifically a **substructural type system**.

At its core, this system treats variables that own resources as, well, _resources_. A resource can be used, and once it's fully given away (or "consumed"), it's gone. This is where the idea of a **linear type system** comes in—a specific flavor of substructural system where a resource must be consumed _exactly once_. When you write let s2 = s1;, the String owned by s1 is consumed by the move. The type system then invalidates s1 to prevent it from being used a second time, thus upholding the "use once" rule.

To enforce this, the compiler uses **flow-sensitive typing**. This means it doesn't just know a variable's type; it tracks its _state_ as it flows through your code. It knows that s1 is valid _before_ the move, but invalid _after_ it. Finally, this system extends to references (& and &mut), which are more than just pointers. They are special types that come with compiler-enforced **invariants**, or rules that must always hold true. The most famous of these is that you can have either many immutable references (readers) or exactly one mutable reference (a writer), but never both at the same time.

Together, these ingredients—a type system that understands consumption, tracks state through program flow, and enforces strict rules on references—form the foundation of Rust's "borrow checker" and its celebrated compile-time safety guarantees.


### Bridging the Divide: Interoperability with C++

This brings us to a crucial question: What happens when we interface with existing C++ code? Rust's strict safety discipline, while a huge benefit, can prevent the direct porting of some perfectly valid C++ APIs. In C++, it's common to write APIs that are safe due to specific, documented invariants that a compiler can't necessarily understand.

A fantastic example is [`absl::node_hash_map`](https://github.com/abseil/abseil-cpp/blob/master/absl/container/node_hash_map.h). This data structure guarantees **pointer stability**: you can look up an element and hold onto a pointer to it, and that pointer will remain valid even if you later mutate the map by adding new elements. This pattern is fundamentally incompatible with Rust's standard aliasing rules. An insert operation on a Rust HashMap requires a unique mutable reference (&mut self), which invalidates all other references to its elements. The Rust compiler has no way to know that Abseil's implementation is special; it sees a violation of its core "aliasing XOR mutability" rule and forbids the code.

So, what would it take to teach Rust's type system about the unique guarantees of `absl::node_hash_map`? You don't. Instead, Rust provides a controlled escape hatch for these situations: the **unsafe** keyword. To wrap such a library, you would write a safe public API that internally uses unsafe blocks to call the C++ code. The Rust wrapper's creator takes on the responsibility of manually upholding the safety invariants that the borrow checker can no longer verify.

This is often accomplished using **interior mutability** primitives like UnsafeCell&lt;T>. This type tells the compiler, "Don't worry about the borrowing rules for this data; I will manage them myself." By wrapping the C++ map pointer in a type that uses UnsafeCell, you can expose methods like insert that take a shared reference (&self) while still performing mutation internally. The key is that this unsafe logic is contained within a small, well-audited boundary, allowing the rest of the Rust application to interact with it in a completely safe and idiomatic way.


### The Path Forward: Beyond "Unsafe"

By using unsafe, we've told the Rust compiler to look away, allowing us to manually uphold the invariants of our C++ library. While this violates Rust's standard rules, it's a pragmatic necessity for interoperability. A lot of code will be written this way, and despite this compromise, the resulting programs are still a massive improvement. The vast majority of the application benefits from Rust's static checking, containing the potential for memory bugs to small, auditable sections—a far safer world than a pure C++ program.

The problem here isn't a flaw in Rust. Its powerful invariants were simply not designed for the C++ ecosystem, where code may arbitrarily hold on to pointers. The manual reasoning required for unsafe blocks is fragile; a future change elsewhere could unknowingly invalidate the assumptions and reintroduce a bug. This highlights a gap in the programming language landscape: there is no smooth gradient from the "no guarantees" world of C++ to the "full, statically checked" world of safe Rust.

This is the gap that experimental projects like **Carbon** aim to fill. Carbon's goal is to devise a language that enables a gradual migration from C++, combining it with the need for full, statically checked memory safety. To succeed, its type system must find a way to provide guarantees around mutable access even in the presence of aliasing. If Carbon can express a concept like pointer stability directly in its types, it would require a different set of global guarantees and aliasing rules than Rust's. The ultimate challenge lies in safely composing programs written in a "legacy C++" style with new code written in a stricter, safer mode, creating a true bridge to a memory-safe future.


### Conclusion: Two Paths to a Safer Future

Throughout this journey, we've seen how a language's type system is the bedrock of memory safety. C++ provides the tools for manual resource management, but places the burden of correctness on the developer. Rust, with its revolutionary ownership, move semantics, and `Copy` trait, shifts that burden to the compiler, turning potential runtime disasters into compile-time errors.

While Rust's model is a monumental step forward, its strictness creates a philosophical divide at the boundary with C++. The `unsafe` keyword offers a pragmatic bridge, but it underscores a fundamental challenge: fitting flexible C++ idioms into Rust's rigid world of invariants.

This is precisely why **Rust and Carbon should not be seen as competitors**, but as different tools for different, equally important jobs.

*   **Rust** 🚀 excels in new, "greenfield" projects where safety is paramount from day one. It's the ideal choice for building new systems or for creating self-contained, high-performance components that integrate with a larger ecosystem through clear API boundaries compatible with its aliasing rules.
*   **Carbon** 🏗️ is designed to tackle a different beast entirely: the gradual and interoperable migration of massive, existing C++ codebases. Its goal is to provide an evolutionary path, allowing teams to incrementally bring parts of their code into a world of statically-checked safety without a complete, high-risk rewrite.

Ultimately, both languages are vital to the future of systems programming. They represent a shared mission to eliminate memory bugs, but they approach it from different starting points—one building a new, safe foundation, and the other building a bridge from the world we already have.

