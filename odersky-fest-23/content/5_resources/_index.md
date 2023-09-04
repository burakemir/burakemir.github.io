+++
title = "Ownership and Resources"
weight = 5
sort_by = "weight"
insert_anchor_links = "right"
+++

Linear logic: formulas act as resources.

**Systems programming**: must ensure safe handling of resources

Here, a resource is an object that is:
   * impossible or costly to copy
   * comes with an obligatory action in the future, e.g. release memory/lock, close file

**"ownership"**: all of the following, simultaneously:
   * access to a resource
   * the *exclusive* responsibility for carrying out the obligatory action

"Modern" C++ [`std::unique_ptr`](https://en.cppreference.com/w/cpp/memory/unique_ptr), move semantics since C++11, the scope-based resource management ([RAII](https://en.wikipedia.org/wiki/Resource_acquisition_is_initialization)) idiom, Rust's type and borrow-checking.
