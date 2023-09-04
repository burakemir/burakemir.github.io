+++
title = "CBPV Rules"
weight = 4
sort_by = "weight"
insert_anchor_links = "right"
+++

$$
\begin{prooftree}
\AxiomC{}
\RightLabel{$(1_I)$}
\UnaryInfC{$\cdot \vdash (): \mathbf{1}$}
\end{prooftree}
\quad
\quad
\begin{prooftree}
\AxiomC{$x : A^+ \in \Gamma$}
\RightLabel{(hyp)}
\UnaryInfC{$\Gamma \vdash x: A^+$}
\end{prooftree}
$$

\\[
\begin{prooftree}
\AxiomC{$\Gamma, x: A^+ \vdash M: B^-$}
\RightLabel{$(\to_I)$}
\UnaryInfC{$\Gamma \vdash (\lambda x: A^+. M):\\, A^+ \rightarrow B^-$}
\end{prooftree}
\quad
\quad
\begin{prooftree}
\AxiomC{$\Gamma \vdash M:\\, A^+ \rightarrow B^-$}
\AxiomC{$\Gamma \vdash N:\\, A^+$}
\RightLabel{$(\to_E)$}
\BinaryInfC{$\Gamma \vdash (M\ N):\\, B^-$}
\end{prooftree}
\\]

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



