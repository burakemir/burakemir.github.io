+++
title = "Tracking Ownership"
weight = 5
sort_by = "weight"
insert_anchor_links = "right"
+++

"there can only be one owner at a time" requires linear (more precisely: affine) type discipline

```rs
// This signature indicates that x is immutable and consumed.
// (toy example, not idiomatic Rust)
fn consuming_reverse(x: String) -> String { ... }

{ 
  let mut y = String::from("hello");
  {
     let s = String::from("bonjour");  

     // s "moves" into y; "hello" is dropped
     y = s;    

     //  print!("{}", s);  // error "borrow of moved value s"
  }

  // y "moves" into consuming_reverse, result "moves" into y
  y = consuming_reverse(y);         
}
```

Escape-hatches: 
  * if a type implements `Copy` can be freely duplicated (bit-wise copy).
  * if a type implements `Clone` can be explicitly duplicated

