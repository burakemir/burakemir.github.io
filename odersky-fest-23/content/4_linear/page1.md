+++
title = "Linear (affine) CBPV"
weight = 5
sort_by = "weight"
insert_anchor_links = "right"
+++

$$
\begin{array}{lll}
A^+ &::= & \mathbf{1}\ |\ \downarrow{A^-} \\\\
B^- &::= & A^+ \multimap B^-\ |\ \uparrow{A^+} 
\end{array}
$$

Note that $\Gamma$ in (hyp) is set, hence affine, and that $\Gamma, \Delta$ is **disjoint**.

$$
\begin{prooftree}
\AxiomC{$x : A^+ \in \Gamma$}
\RightLabel{$(\mathrm{hyp})$}
\UnaryInfC{$\Gamma \vdash x: A^+$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma, x: A^+ \vdash s: B^-$}
\RightLabel{$(\multimap_I)$}
\UnaryInfC{$\Gamma \vdash (\lambda x: A^+. s):\\, A^+ \multimap B^-$}
\end{prooftree}
\quad
\quad
\begin{prooftree}
\AxiomC{$\Gamma \vdash s:\\, A^+ \multimap B^-$}
\AxiomC{$\Delta \vdash t:\\, A^+$}
\RightLabel{$(\multimap_E)$}
\BinaryInfC{$\Gamma, \Delta \vdash (s\ t):\\, B^-$}
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
\AxiomC{$\Delta, x: A^+ \vdash t:\\, C^-$}
\RightLabel{$(\uparrow_E)$}
\BinaryInfC{$\Gamma, \Delta \vdash \mathtt{let\ val}\ x = s\ \mathtt{in}\ t:\\, C^-$}
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



