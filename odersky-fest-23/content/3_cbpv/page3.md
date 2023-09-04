+++
title = "Sums and products"
weight = 5
sort_by = "weight"
insert_anchor_links = "right"
+++

$$
\begin{array}{lll}
A^+ &::= & \mathbf{1}\ |\ {\color{green}{\Sigma_{i \in I} A_i}}\ |\ {\color{green}{A_1^+ \times A_2^+}}\ |\ \downarrow{A^-} \\\\
B^- &::= & A^+ \rightarrow B^-\ |\ {\color{blue}{\Pi_{i \in I}\ i.B_i^-}}\ |\ \uparrow{A^+} 
\end{array}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash v: A_j^+$}
\RightLabel{$(+_I)$}
\UnaryInfC{$\Gamma \vdash \mathtt{inj}_i\ v : {\color{green}{\Sigma_I A^+_i}}$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma \vdash v : {\color{\green}{\Sigma_I A^+_i}}$}
\AxiomC{$\ldots \Gamma, x: A_i^+ \vdash M_i : B^- \ldots$}
\RightLabel{$(+_E)$}
\BinaryInfC{$\Gamma \vdash \mathtt{match}\ V\ \\{\ldots, \mathtt{case}\ i: x.M_i \ldots\\}: B^-$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash v_1: A_1^+$}
\AxiomC{$\Gamma\vdash v_2: A_2^+$}
\RightLabel{$(\times_I)$}
\BinaryInfC{$\Gamma \vdash (v_1, v_2) :\\, {\color{green}{A_1^+ \times A_2^+}}$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash v: {\color{\green}{A_1^+ \times A_2^+}}$}
\AxiomC{$\Gamma, x: A_1^+, y: A_2^+ \vdash M: B^-$}
\RightLabel{$(\times_E)$}
\BinaryInfC{$\Gamma \vdash \mathtt{match}\ V\ \mathtt{as}\ (x, y).M : B^-$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\ldots \Gamma \vdash s_i: B_i^- \ldots$}
\RightLabel{$(\Pi_I)$}
\UnaryInfC{$\Gamma \vdash \lambda\\{\ldots i.s_i\ldots \\}: {\color{blue}{\Pi_I\ i.B_i^-}}$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash s : {\color{blue}{\Pi_{i \in I}\ i.B_i^-}}$}
\RightLabel{$(\Pi_E)$}
\UnaryInfC{$\Gamma \vdash s\ \mathtt{get}\ i: B_i^-$}
\end{prooftree}
$$


