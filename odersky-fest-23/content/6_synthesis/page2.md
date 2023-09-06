+++
title = "Linear but how"
weight = 7
sort_by = "weight"
insert_anchor_links = "right"
+++

Literature approaches to bring linear logic into programming

Includes memory safety, eg. uniqueness types. Reynolds "syntactic control of inference" 1978.

Relevant to the problem of shared references:

   * Phil Wadler "Is there a use for linear types?" ACM SIGPLAN Notices 26 (9) '91
   * Martin Odersky "Observers for linear types" ESOP'92

Key points:
   * local/short-lived read-only aliasing is ok for a linear type!
      * **Key ingredient of Rust type discipline.**
   * need rules to combine linear and non-linear types in compound data types.
      * practical application: [splitting borrows](https://doc.rust-lang.org/nomicon/borrow-splitting.html)

Questions:
   * can we do without exponentials?
      * In Rust, a type (atom) either "is Copy" or not. Auto-derivation (e.g. Send)
   * dealing with context when linear / non-linear types are combined. bunched implications
   * can the simple model be extended with "par" and "fearless concurrency" properties
