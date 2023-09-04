+++
title = "CBPV Examples"
weight = 4
sort_by = "weight"
insert_anchor_links = "right"
+++

$$
\begin{array}{l}
\lambda f:\\,(A \rightarrow A). \lambda x:A. \\\\
\quad f\ (f\ x)
\end{array}
\quad
\quad
\begin{array}{l}
\lambda f:\\,\downarrow(A^+ \rightarrow\\, \uparrow\\!A^+). \lambda x:A^+. \\\\
\quad\mathtt{let\ val}\ y\ =\ (\mathtt{force}\ f)\ x\ \mathtt{in} \\\\ 
\quad\mathtt{return}\ \(\mathtt{force}\ f)\ y
\end{array}
$$




