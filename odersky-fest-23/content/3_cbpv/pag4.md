+++
title = "Effects"
weight = 6
sort_by = "weight"
insert_anchor_links = "right"
+++

With evaluation order fixed, it becomes easy to absorb sequences effectful actions into semantics.

An $\mathcal{A}$-set $(X, \star)$ is:
   * set $X$ together with 
   * a function $\star$ from $\mathcal{A} \times X$ to $X$.

Key idea: 
   * a closed term $M$ of computation type $B$ denotes an element $[\\![ M ]\\!]$ of $X$.
   * an effectful operation $ \mathit{op}; M $ where $\mathit{op}$ should produces an action $c$ denotes $c \star [\\![ M ]\\!]$ 

Simple example: $\mathtt{print!}\(s)$ where $c$ is the action of printing $s$.

The *free* $\mathcal{A}$-set has carrier $\mathcal{A}^* \times X$.

Concatenating actions: $c \star (m, X) = (c \star m, X)$.

$$
\begin{prooftree}
\AxiomC{$M \Downarrow m, T$}
\UnaryInfC{$\mathtt{print!}\(s). M \Downarrow s \star m, T$}
\end{prooftree}
$$
