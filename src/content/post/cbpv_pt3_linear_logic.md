+++
title = "CBPV and Natural Deduction - Part 3. Linear Logic"
date = 2023-08-25
[taxonomies]
categories = ["blog"]
tags = ["logic", "abstract machine", "cbpv"]
[extra]
math = true
+++

Welcome back to our study of polarized natural deduction and what 
CBPV has to do with it. For the previous parts 
of this journey, check out ["pt1. small steps"](@/post/cbpv_pt1_small_steps.md)
and ["pt2. sums and products"](@/post/cbpv_pt2_sum_product.md).

## What happened so far

In part 1, we introduced the essential parts of call-by-push-value (CBPV):
splitting types into value and computation types, with shifts between
these worlds. We saw that static typing constrains evaluation order,
without the need for an external specification like evaluation context
definition, and that this enables us to give an abstract machine.
Although the CK machine still uses substitution, the fact that it
only looks at bounded depth from the root makes it already a lot
more efficient than a recursive evaluator that has to descend
a term and looks for redexes. We hinted at the connection with
intermediate representation in compilers, given that all
intermediate results are named.

In part 2, we added sum and products tyes as value types, and also a
second product type as computation type. We hinted that the difference 
between the two product types has to do with linear logic.

In this part, we reveal how linear logic relates to these two
different kind of product types. The very notion of propositions having 
polarity comes from linear logic; going in this direction is
a deliberate choice in order to simple, intuitive explanation.

Another choice to discuss CBPV is to focus on natural deduction.
Almost all linear logic discourse happens on sequent calculi, but
Prawitz that natural deduction is illuminating, as witnessed by
the fact that the simplest example of Curry-Howard-Lambek
correspondence is between $\lambda$ calculus and natural deduction
for minimal logic.

Let us dive right in and get from natural deduction to linear natural deduction.

## Assumptions and Linearity

We formulated our typing rules in the standard way, with judgments
that read $\Gamma \vdash e : T$. In terms of logic, this is a
hypothetical judgment "$T$ is true under assumptions $\Gamma$".

This style of writing judgments is called "localized assumptions" or 
sometimes sequent style: all available assumptions are repeated on 
every node of our derivation. Most treatments of natural deduction
instead assumptions as some leaf nodes that are marked when
they are discharged.

In the programming view, assumptions are assignments of a type to a variable. 
In using the $\lambda$-calculus as a programming language, we can use
variables in an unconstrained maner, as in these expressions:

   * $\mathrm{twice} := \lambda f: A \rightarrow A. \lambda x: A. f (f x)$ and $\mathrm{double} := \lambda x: Int. x + x$
   * $\mathrm{K} := \lambda x. \lambda y. x$

Type derivations for the bodies $f (f x)$ and $x + x$ and $x$ will use variables
from the typing context more than once. In the case of $K$, there will be 
variable $y$ introduced to the context that is not used at all.
These examples show that we use $\Gamma$ as a set of assumptions. We can freely
use anything that is in the set.

*Linearity* use a variable exactly once. Just as in mathematics, a linear equation has 
the shape $a * x + b = 0$ where $x$ is used once (with $a \neq 0$, thus polynomial degree 1), in *linear logic*,
we are interested in the case that an assumption is used exactly once. 
Why would we do this? There are many concrete applications to linearity
in programming languages. The one we will be most interested in is the 
inherent notion of *exclusive ownership* that comes from treating types
as resources.
 
A close friend of linearity is *affinity* where polynomial degree may
be either 1 or 0. We can ignore variables. This is pretty interesting as
you can see from the examples: with an affine type system, we can still
assign a type to terms like $K$ combinator that ignore variables.
The more practical example is code like this:

```
fn (x: &mut u32) {
  if (some_condition()) { *x = 1; }
}
```

<!--
There is more to say about linear logic than these applications, but for 
our purposes, understanding CBPV as polarized natural deduction (with an
application to tracking exclusive ownership) this is sufficient.
-->

<!--
Note that if a program was already linear, our rules would already be 
good for typing it. We now want to refine our typing rules so that only
linear programs, to exclude the possibility
of using a variable more than once.
-->

<!--
We can still consider the context to be a set; we just need to careful
when the rules combine typing contexts. We want to make sure that contexts
are disjoint sets.
-->
<!--
Consequently, the expressions above will not be typable. The types come with
an inherent ownership: they are resource, and - in modern programming terms -
a $\lambda$ expression has *ownership* of these resources. When we combine
derivations, we make explicit that they do not share any assumptions.
Let's jump right in.
-->

## Linear CBPV

We can now define a linear natural deduction calculus, using the standard notation for
linear logic connectives. We will do this by simply repeating all the rules
we had previously for call-by-push-value, but now with the added constraint
that variables (assumptions) are used exactly once. For the judgment
$\Gamma \vdash e: T$ we require that exactly the free variables in $e$ appear in $\Gamma$.
If we want an affine type discipline instead, we require that $\Gamma$ be a superset
of all the variables in $e$.

$$
\begin{prooftree}
\AxiomC{$x : A^+ \in \Gamma$}
\RightLabel{$(\mathrm{hyp})$}
\UnaryInfC{$\Gamma \vdash x: A^+$}
\end{prooftree}
$$

Introduction and elimination rules for *linear implication* $\multimap$.
Note how we use $\Delta$ to emphasize that variables are disjoint from $\Gamma$.

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

Linear implication $A^+ \multimap B^-$ is different from arrow type: 
the argument resource $A^+$ is *consumed* and in return we get a certain
computation resource $B^-$.

Now comes the shift from values to computations. As before, if you
compare with [part 1](@/post/cbpv_pt1_small_steps.md), the only difference 
is that there is a separate, disjoint context named $\Delta$.

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

This is easy! The rules for introducing $(\downarrow_I)$ and eliminating
 $(\downarrow_E)$ the shift from computation to values do not actually change so
we don't repeat them here (consult [part 1](@/post/cbpv_pt1_small_steps.md)).
We have defined a core linear CBPV calculus with abstraction and application.

## Sums and Products

We move on to sum and product types discussed in [part 2](@/post/cbpv_pt2_sum_product.md). There,
we noticed two distinct product types: a value pair type and a computation record type.

The sum and product value types correspond to disjunction and conjuction in minimal and intuitionistic 
logic. In linear logic, there are multiple ways to define disjunction. We use standard, but different symbols 
for the corresponding linear logic connectives.

The linear version of our sum value type correspons to *additive disjunction* $\oplus$ (still called "plus"):
$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash v: A_j^+$}
\RightLabel{$(\oplus_I)$}
\UnaryInfC{$\Gamma \vdash \mathtt{inj}_i\ v : {\color{lightgreen}{{\large \oplus}_I A^+_i}}$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma \vdash v : {\color{\lightgreen}{{\large \oplus}_I A^+_i}}$}
\AxiomC{$\ldots \Delta_i, x: A_i^+ \vdash M_i : B^- \ldots$}
\RightLabel{$(\oplus_E)$}
\BinaryInfC{$\Gamma \ldots \Delta_i \ldots \vdash \mathtt{match}\ V\ \\{\ldots, \mathtt{case}\ i: x.M_i \ldots\\}: B^-$}
\end{prooftree}
$$

Our pair value type, as hinted at in the last part, is *multiplicative conjunction* $\otimes$ ("tensor"): we cannot
use a component of a pair and drop the other one, we have to use both.

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash v_1: A_1^+$}
\AxiomC{$\Delta\vdash v_2: A_2^+$}
\RightLabel{$(\otimes_I)$}
\BinaryInfC{$\Gamma, \Delta \vdash (v_1, v_2) :\\, {\color{lightgreen}{A_1^+ \otimes A_2^+}}$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash v: {\color{\lightgreen}{A_1^+ \otimes A_2^+}}$}
\AxiomC{$\Delta, x: A_1^+, y: A_2^+ \vdash M: B^-$}
\RightLabel{$(\otimes_E)$}
\BinaryInfC{$\Gamma, \Delta \vdash \mathtt{match}\ V\ \mathtt{as}\ (x, y).M : B^-$}
\end{prooftree}
$$

Finally, let us look at the "lazy" (unevaluated) pair computation type. This connective
is called additive conjunction and written $\\&$ (pronounced "with").
For a linear record of computation, we cannot use multiple fields, we can pick one, 
losing access to the rest.

$$
\begin{prooftree}
\AxiomC{$\ldots \Gamma_i \vdash s_i: B_i^- \ldots$}
\RightLabel{$({\large \\&}_I)$}
\UnaryInfC{$\ldots \Gamma_i \ldots \vdash \lambda\\{\ldots i.s_i\ldots \\}: {\color{lightblue}{{\large \\&}_I\ i.B_i^-}}$}
\end{prooftree}
$$

$$
\begin{prooftree}
\AxiomC{$\Gamma\vdash s : {\color{lightblue}{{\large \\&}_{i \in I}\ i.B_i^-}}$}
\RightLabel{$({\large \\&}_E)$}
\UnaryInfC{$\Gamma \vdash s\ \mathtt{get}\ i: B_i^-$}
\end{prooftree}
$$

We have defined a linear CBPV calculus with "plus" $\oplus$ (additive disjunction), 
"tensor" $\otimes$ (multiplicative conjuction) and "with" $\\&$ (additive conjunction) .

At this point, you may wonder about the missing combination: multiplicative disjunction. This
is written &#x214b; (pronounced "par") and corresponds to a sort of separate composition (say, 
parallel composition of processes).  Other notions of composition along two dimension work,
too, for instance space and time (fun fact that concurrency is "Nebenl&auml;ufigkeit" in German,
which "side-by-side running").  All this and more linear logic concepts would lead us slightly
too far away from our series topic. 

## Towards an understanding of polarity

In our journey to understand polarity in natural deduction, we have arrived at a happy place that
lets us see a clear and easy to remember way to relate computation to CBPV, understood
as the analogon of an intermediate representation in a compiler. The order of evaluation
is specified without the help of external means.

In the next and final part, we shall look at polarity in more detail and discuss possible
applications for programming language implementation.

