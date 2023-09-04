+++
title = "Call-by-push-value and Ownership"
weight = 1
sort_by = "weight"
insert_anchor_links = "right"
+++

Talk at [OderskyFest](https://www.cs.cmu.edu/~oderskyfest/) 2023-09-05 EPFL Lausanne

Who is Burak Emir?

- at LAMP 2002-2007, translation of pattern matching in `scalac` 
  - extractor patterns aka "unapply"
- occasionally applying programming language technology at work
   - e.g. [Mangle](https://github.com/google/mangle), an extended datalog with types
   - Rust for large-scale distributed systems

"*A scientist builds in order to learn; an engineer learns in order to build.*" (Fred Brooks)

This talk: towards simple formalization of Rust's ownership and borrowing
   - evaluation order, call-by-push-value (CBPV)
   - linear logic: types as resources
   - ownership, memory safety (with examples in Rust)
   - early ideas on how it could fit together

Disclaimer: The views expressed here are my own and do not represent my employer.

