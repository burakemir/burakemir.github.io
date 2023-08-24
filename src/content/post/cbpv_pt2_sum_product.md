+++
title = "CBPV and Natural Deduction - Part 2. Sums and Products"
date = 2023-08-20
[taxonomies]
categories = ["blog"]
tags = ["logic", "abstract machine", "cbpv"]
[extra]
math = true
+++
We are continuing our look at call-by-push-value (CBPV), natural deduction and
abstract machines. [Last time](@/post/cbpv_pt1_small_steps.md) we looked
at a bare-bones version so we could focus on $\lambda$-abstraction and
application.

In this part, we will only add sum and product types. In the next part we can
then shift our view towards linear logic concepts and resources.

## Sum and Product Types

We add a sum type $ \Sigma A_i $ and a product type $A_1 \times A_2$ to our value types. We also add lazy products,
$\Pi_{i \in I}\ i.B_i^-$ for reasons that have to do with the fine-grained distinction between
value and computation types.  The presentation in this section follows Levy's book closely, except
minor changes in syntax.

<!-- par &#x214B; -->

$$
\begin{array}{lll}
A^+ &::= & \mathbf{1}\ |\ {\color{lightgreen}{\Sigma_{i \in I} A_i}}\ |\ {\color{lightgreen}{A_1^+ \times A_2^+}}\ |\ \downarrow{A^-} \\\\
B^- &::= & A^+ \rightarrow B^-\ |\ {\color{lightblue}{\Pi_{i \in I}\ i.B_i^-}}\ |\ \uparrow{A^+} 
\end{array}
$$

By looking at the introduction and elimination rules, we can get intuition what  sum types are.
can construct value of sum type by *injecting*, and when we have a value of sum type,
we can perform a case-distinction and recover which injector was used. We use a $\mathtt{match}$
syntax for the case distinction. The only special thing for CBPV is that sum types are
made from value types, they are themselves value types, but a match is a computation and
therefore yields a computation type.

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash v: A_j^+$}
\RightLabel{$(+_I)$}
\UnaryInfC{$\Gamma \vdash \mathtt{inj}_i\ v : {\color{lightgreen}{\Sigma_I A^+_i}}$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma \vdash v : {\color{\lightgreen}{\Sigma_I A^+_i}}$}
\AxiomC{$\ldots \Gamma, x: A_i^+ \vdash M_i : B^- \ldots$}
\RightLabel{$(+_E)$}
\BinaryInfC{$\Gamma \vdash \mathtt{match}\ V\ \\{\ldots, \mathtt{case}\ i: x.M_i \ldots\\}: B^-$}
\end{prooftree}
$$

We do the same with a pair type: using pair syntax constructs a pair, both components
have to be value types and the pair itself is a value type. Elimination is interesting:
we require that both values are bound at the same time. The reason for this is that
in CBPV, projection would be a computation.

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash v_1: A_1^+$}
\AxiomC{$\Gamma\vdash v_2: A_2^+$}
\RightLabel{$(\times_I)$}
\BinaryInfC{$\Gamma \vdash (v_1, v_2) :\\, {\color{lightgreen}{A_1^+ \times A_2^+}}$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash v: {\color{\lightgreen}{A_1^+ \times A_2^+}}$}
\AxiomC{$\Gamma, x: A_1^+, y: A_2^+ \vdash M: B^-$}
\RightLabel{$(\times_E)$}
\BinaryInfC{$\Gamma \vdash \mathtt{match}\ V\ \mathtt{as}\ (x, y).M : B^-$}
\end{prooftree}
$$

Taken together, the value types for sums and products are enough to give us sum-of-product algebraic datatypes,
though pattern matching operates only on one level at a time.

In terms of logic, sums are disjunction and pairs are conjunction. Defining pairs 
in this way is a harbinger of what is to follow in the next part: Bob Harper says one
might as well write $v_1 \otimes v_2$ (tensor) in his post
on [polarity in type theory](https://existentialtype.wordpress.com/2012/08/25/polarity-in-type-theory/),
but admits it is pointless if we are not doing linear logic.
We leave this discussion of linear logic to the next part.

Now we come to the "lazy product", which is closer in spirit to records of functions (which could
be called "objects", but this is simplifying objects a lot). We bundle suspended computations in a
record, and we have a computation to select a particular "field" from this record.

<!--\UnaryInfC{$\Gamma \vdash \lambda\\{\\} :\\, $}-->
$$
\begin{prooftree}
\AxiomC{$\ldots \Gamma \vdash s_i: B_i^- \ldots$}
\RightLabel{$(\Pi_I)$}
\UnaryInfC{$\Gamma \vdash \lambda\\{\ldots i.s_i\ldots \\}: {\color{lightblue}{\Pi_I\ i.B_i^-}}$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash s : {\color{lightblue}{\Pi_{i \in I}\ i.B_i^-}}$}
\RightLabel{$(\Pi_E)$}
\UnaryInfC{$\Gamma \vdash s\ \mathtt{get}\ i: B_i^-$}
\end{prooftree}
$$

Also here, we shall leave the corresponding linear logic connector, \& "with", for the next part.

## Machine Transitions

We extend the CK machine accordingly. There is a new stack frame $(\\_ \mathtt{get}\ i)$, otherwise
the transitions are as one would expect them. As before, the heavy lifting in CK machine is done 
by substitution.

$$
\begin{array}{llll}
C                                        & K & \rightsquigarrow & C' & K' \\\\
s\ \mathtt{get}\ i         & k & & s   &  (\\_ \mathtt{get}\ i)::k \\\\
\lambda\\{\ldots i.s_i\ldots \\}         & (\\_ \mathtt{get}\ i)::k & & s_i   &  k \\\\
\mathtt{match} (v_1, v_2)\ \mathtt{as}\ (x, y).M  & k &                 & M[x := v_1, y:= v_2]  & k \\\\
\mathtt{match} (\mathtt{inj}\ i\ v) \\{ \ldots \mathtt{case}\ i: x.M_i\ldots \\} & k &                 & M_i [x:=v] & k \\\\
\end{array}
$$

## Preview of the next part

We have discussed CBPV following a narrative of polarized natural deduction. There
were some previews of linear logic discussion, but fundamentally, the types could
not yet be interpreted as linear logic proposition.

The reason for this is that in natural deduction, assumptions can be used multiple 
times and discharged whenever we want. This corresponds to the structural rules of 
sequent calculus, of which Girard says they are the most important of them all.

$$
\begin{prooftree}
\AxiomC{$x : A^+ \in \Gamma$}
\RightLabel{$(\mathrm{hyp})$}
\UnaryInfC{$\Gamma \vdash x: A^+$}
\end{prooftree}
$$

Therefore, if we want to set up linear natural deduction, we have to first
make precise where and how this unconstrained use of hypotheses takes place.
We can then see how to change perspective and decree that assumptions can be
used exactly once (linear) or up to once (affine). Stay tuned for the next
session.

