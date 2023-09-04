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

becomes
$$
\begin{array}{lll}
A^+ &::= & \mathbf{1}\ |\ {\color{green}{\oplus_{i \in I} A_i}}\ |\ {\color{green}{A_1^+ \otimes A_2^+}}\ |\ \downarrow{A^-} \\\\
B^- &::= & A^+ \multimap B^-\ |\ {\color{blue}{\\&_{i \in I}\ i.B_i^-}}\ |\ \uparrow{A^+} 
\end{array}
$$


$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash v: A_j^+$}
\RightLabel{$(\oplus_I)$}
\UnaryInfC{$\Gamma \vdash \mathtt{inj}_i\ v : {\color{green}{{\large \oplus}_I A^+_i}}$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma \vdash v : {\color{\green}{{\large \oplus}_I A^+_i}}$}
\AxiomC{$\ldots \Delta_i, x: A_i^+ \vdash M_i : B^- \ldots$}
\RightLabel{$(\oplus_E)$}
\BinaryInfC{$\Gamma \ldots \Delta_i \ldots \vdash \mathtt{match}\ V\ \\{\ldots, \mathtt{case}\ i: x.M_i \ldots\\}: B^-$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash v_1: A_1^+$}
\AxiomC{$\Delta\vdash v_2: A_2^+$}
\RightLabel{$(\otimes_I)$}
\BinaryInfC{$\Gamma, \Delta \vdash (v_1, v_2) :\\, {\color{green}{A_1^+ \otimes A_2^+}}$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash v: {\color{\green}{A_1^+ \otimes A_2^+}}$}
\AxiomC{$\Delta, x: A_1^+, y: A_2^+ \vdash M: B^-$}
\RightLabel{$(\otimes_E)$}
\BinaryInfC{$\Gamma, \Delta \vdash \mathtt{match}\ V\ \mathtt{as}\ (x, y).M : B^-$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\ldots \Gamma_i \vdash s_i: B_i^- \ldots$}
\RightLabel{$({\large \\&}_I)$}
\UnaryInfC{$\ldots \Gamma_i \ldots \vdash \lambda\\{\ldots i.s_i\ldots \\}: {\color{blue}{{\large \\&}_I\ i.B_i^-}}$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash s : {\color{blue}{{\large \\&}_{i \in I}\ i.B_i^-}}$}
\RightLabel{$({\large \\&}_E)$}
\UnaryInfC{$\Gamma \vdash s\ \mathtt{get}\ i: B_i^-$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma \vdash s: A^+$}
\RightLabel{$(\uparrow_I)$}
\UnaryInfC{$\Gamma \vdash \mathtt{return}\ s:\\, \uparrow\\!{}A^+$}
\end{prooftree}
\quad
\quad
\begin{prooftree}
\AxiomC{$\Gamma \vdash s:\\, \uparrow\\!{}A^+$}
\AxiomC{$\Gamma, x: A^+ \vdash t:\\, C^-$}
\RightLabel{$(\uparrow_E)$}
\BinaryInfC{$\Gamma \vdash \mathtt{let\ val}\ x = s\ \mathtt{in}\ t:\\, C^-$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma \vdash k: A^-$}
\RightLabel{$(\downarrow_I)$}
\UnaryInfC{$\Gamma \vdash \mathtt{thunk}\ k:\\, \downarrow\\!{}A^-$}
\end{prooftree}
\quad
\quad
\begin{prooftree}
\AxiomC{$\Gamma \vdash t:\\, \downarrow\\!{}A^-$}
\RightLabel{$(\downarrow_E)$}
\UnaryInfC{$\Gamma \vdash \mathtt{force}\ t:\\, A^-$}
\end{prooftree}
$$


