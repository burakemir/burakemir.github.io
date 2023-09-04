+++
title = "Evaluation Order"
weight = 2
sort_by = "weight"
insert_anchor_links = "right"
+++

In school, we learn to "look past" order of evaluation $(a + b) + (c + d)$

In programming, we learn not to:
```rust
fn add(a: u8, b: u8, c: u8, d: u8) -> u8 {
  let x = a + b; 
  let y = c + d;
  x + y
}
```
Reviewer comment: `please check overflow?`
```rust
fn add(a: u8, b: u8, c: u8, d: u8) -> Option<u8> {
  let x = a.checked_add(b)?;
  let y = c.checked_add(d)?;
  x.checked_add(y)
}
```

(The ? operator works for `Result<T,E>` and for `Option<T>`)

Fixing evaluation order helps reason about *effects* (side-effects, failure, non-termination...)

