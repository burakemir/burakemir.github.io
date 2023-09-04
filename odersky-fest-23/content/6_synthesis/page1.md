+++
title = "Monadic intermediate form"
weight = 1
sort_by = "weight"
insert_anchor_links = "right"
+++

Simple Rust program
```rs
let mut x = 0;
for i in 2..n {
  x = x * i;
}
return x
```
can be translated to monadic intermediate form (~CBPV + sugar)
```rs
let x = mkref 0 in
let _loop = thunk λ_. 
  let i = mkref 2 in
  let _body = thunk λ_. return x := x * i; () in
  return if i < n {
    (force _body) (); i := i + 1; (force _loop) (); ()
  } else { () } in
(force _loop) ();
return x
```
Identifiers `_foo` are like labels.

"Local" alias = local to a "block"

Check linearity, references by looking at context
