+++
title = "Call by Push Value (CBPV)"
weight = 3
sort_by = "weight"
insert_anchor_links = "right"
+++

A variant of typed \\(\lambda\\)-calculus that makes evaluation order explicit.

This helps with capturing effects formally. "functional/imperative synthesis" (Levy)

Types come in two polarities:
  * value (positive) types
  * computation (negative) types

\\[
\begin{array}{lll}
B^- &::= & A^+ \rightarrow B^-\ |\ \uparrow{A^+} \\\\
A^+ &::= &\mathbf{1}\ |\ \downarrow{B^-}
\end{array}
\\]


