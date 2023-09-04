+++
title = "Flow and more"
weight = 8
sort_by = "weight"
insert_anchor_links = "right"
+++

More general question:
   * other areas where splitting value vs computations (CBPV) may helps?
   * can we cover user-definable actions (RAII, implement Drop)?
   * e.g. do abstract interpretation on abstract machine traces

What we know:
  * CBPV is closer to compiler IR (naming intermediate results, evaluation order)
  * easy to define abstract machine, also for open terms

Questions:
  * If we go further (ANF), do we close the gap towards SSA (used in LLVM-based Rust backend)?
  * can a model of Rust type-discipline also be to improve C++ programs?
    * dataflow analysis, instead of type-discipline, check through static analysis
