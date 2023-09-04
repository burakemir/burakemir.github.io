+++
title = "References and Flow"
weight = 5
sort_by = "weight"
insert_anchor_links = "right"
+++

Martin Odersky described in "Observers for linear types" ESOP'92

> Linear types provide the framework for a safe embedding of mutable state in
functional languages by enforcing the principle that variables of linear type must
bc used exactly once. A potential disadvantage of this approach is that it places
read accesses to such variables under the same restriction as write accesses [...]

Through **[references and borrowing](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html)**,
we can grant ownership for duration of a function call.

   * mutable references `&mut T`  - temporary ownership
   * shared, immutable references `&T` (~ "observers")

```rs
fn main() {
    let s1 = String::from("hello");
    let len = calculate_length(&s1);
    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}
```


Borrowing is best understood as **flow-sensitive type discipline.**

* only a single mutable reference can exist in a scope
* many immutable references can be created
* a mutable reference can be reborrowed as immutable
* however, the mutable reference cannot be used as long as immutable
references exist "No Mutable Reference with Live Immutable Reference"

```rs
  let mut s = String::from("hello");
  let r1 = &s;     // no problem
  let r2 = &mut s; // error "cannot borrow `s` as mutable because it is also borrowed as immutable"
```

Duration of temporary access: tracked through **lifetime parameters.**

