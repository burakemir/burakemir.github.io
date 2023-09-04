+++
title = "Resource and scopes"
weight = 5
sort_by = "weight"
insert_anchor_links = "right"
+++

Some rules for [ownership in Rust](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html):
* Each value in Rust has an owner.
* there can only be one owner at a time.
* When the owner goes out of scope, the value will be **dropped**
```rs
{
  let s = String::from("hello"); // allocates buffer on heap
  // do stuff with s
  print!("{}", s);
}                 // s out-of-scope, String buffer released
```

When a value is dropped, we can perform end-of-life actions before releasing memory.


```rs
fn baz(mutex: Mutex, ...) {
    let guard = mutex.lock();  // lock acquired at initialization
    // do stuff
} 
// mutex automatically unlocked when guard is dropped
```

This idiom is also called "resource-acquisition-is-initialization," though
a better name is scoped-based resource management.
