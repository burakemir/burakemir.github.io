+++
title = "Memory effects"
weight = 2
sort_by = "weight"
insert_anchor_links = "right"
+++

Add shared reference types:
  * $\mathtt{\\&mut} A^+$ and $\mathtt{\\&}\ A^+$
  * add operation to dereference $*x$.
  * reborrow $\mathtt{\\&}\\!*x$: shared reference, "observe" resource $x$

Now, these effectful operations will be useful:

   * $\mathtt{alloc}_A$: allocates memory for $A^+$, returns location.
      * the memory is a resource, follow linear type discipline
   * $\mathtt{store}_A(x, v)$: stores $v$ in location $x$, given $x: \mathtt{\\&mut}\ A^+$ and $v: A^+$
   * $\mathtt{drop}_A(x)$: releases memory for T, given $x: T$


$$
\begin{prooftree}
\AxiomC{$\Gamma \vdash x: \mathtt{\\&}A^+$}
\UnaryInfC{$\Gamma \vdash *x: A^+$}
\end{prooftree}
\quad
\quad
\begin{prooftree}
\AxiomC{$\Gamma \vdash x: \mathtt{\\&mut}\ A^+ $}
\UnaryInfC{$\Gamma \vdash *x: A^+$}
\end{prooftree}
$$

Combining contexts: ensure that for any $x: A^+$ there is either:
   * at most one "active" mutable reference $\mathtt{\\&mut} A^+$ (keep track of location), or
   * arbitrary number of shared references $\mathtt{\\&} A^+$ 

"deactivate" mutable reference when reborrow: e.g. add conditions for $\mathtt{store}$.

(details remain to be worked out)
