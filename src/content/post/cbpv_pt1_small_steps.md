+++
title = "CBPV and Natural Deduction - Part 1. Small steps"
date = 2023-07-22
[taxonomies]
categories = ["blog"]
tags = ["logic", "abstract machine", "cbpv"]
[extra]
math = true
+++
I have been reading up on call-by-push-value (CBPV),
a variation of $\lambda$-calculus that is more
fine-grained in its treatment of argument-passing.
I then came across a chapter
from Frank Pfenning's 2016 [lecture notes on substructual logic](https://www.cs.cmu.edu/~fp/courses/15816-f16/schedule.html) that 
characterizes CBPV as *polarized natural deduction.* In a small series
of posts, I am exploring what this means and how this relates to
compilers.

The Curry-Howard-Lambek correspondence is a nice way to connect logic and computation. 
I have written about this in previous posts on my old blog, see
[Higher-order logic and equality](https://bq9.blogspot.com/2020/04/higher-order-logic-and-equality.html)
and
[Intuitionistic Propositional Logic and Natural Deduction](https://bq9.blogspot.com/2020/05/intuitionistic-propositional-logic-and.html).
For the first part, those posts should be enough to tag along.
In the next parts, we may look at some fine points of natural deduction.

<!--
we sequential composition
Now CBPV raises a question:
A few reasons: 
* What does this "finer-grained treatment of passing arguments" correspond to
in this logical perspective? 
* if we instead regard $\lambda$-calculus as a model of computation, there are
also *abstract machines* which would be more fine-grained models of computation.
Does CBPV yield insights that we can put to good use when passing from
the $\lambda$-calculus to the lower-level machine formalisms? Could these
insights help us with the design of intermediate representations (IR) for
compilers that would support reasoning about correctness of program
transformations and optimizations?
-->
<!--
For the second perspective, there will be a follow up at some point. For
a sneak preview, consider the a paper [Structural Operational Semantics for Control Flow Graph Machines](https://arxiv.org/abs/1805.05400') by Dmitri Garbuzov, William Mansky, Christine Rizkallah, Steve Zdancewic.
-->

# Reduction and strategy

In $\lambda$-calculus, our elementary computation step is a $\beta$-reduction. 
Taking the perspective of the Curry-Howard-Lambek correspondence, we can regard 
a type as a logical proposition and a term of typed $\lambda$-calculus as a proof 
of this proposition. Here, $\beta$-reduction is a rewriting
of the proof, which removes a 'detour' in the proof. In other words, computation is proof normalization.

$$
( \lambda x : A .  t)\ s \longrightarrow_β t [ x := s ]
$$

Here, $[ x := s ]$ is our way of writing substitution. The full definition requires 
the usual careful treatment of bound names. The rewriting can take place anywhere in
the term.
<!--
Resource-efficient programming language implementations require
*lowering* substitution and symbolic representation, i.e. find lower-level representations 
that have same meaning (operational semantics). But let's not get ahead of ourselves:
we should first have an operational semantics.
-->

Suppose we wanted to specify the *order* of computation steps. When there are not one, but several reducible expressions,
which reduction should happen first?

A small-step semantics would specify not only reduction, but also where exactly evaluation takes place.
To this end, one defines *evaluation context*, a term with a hole that specifies exactly
where in the term reduction is permitted to happen. Here is a sample definition, where we consider
$\lambda$-abstractions as values (we do not reduce under a $\lambda$.)

$$
\begin{array}{lll}
E &::= &x\ |\ \lambda x. E\ |\ E\ E \\\\
C &::= &[~]\ |\ E\ C\ |\ C\ V \\\\
V &::= &\lambda x. E
\end{array}
$$

When we have a context, we can fill its hole with a $\lambda$-expression and now exactly
where evaluation takes place. The hole of a context could also be filled with another
context.

The definition of evaluation contexts forces the argument (operand) in
an application to be evaluated before the operator. The example above is thus a form
of call-by-value. Note that the definition of $C$ comes with a somewhat arbitrary decision to evaluate the operand
before the operator. For call-by-name, passing a term that is not value would
require a context like $[~]\ E$. 

Our specification of evaluation contexts seems to impose order by
defining what form of argument-passing is possible; in other
words, constraining (or leaving unconstrained) what can be bound to an identifier.

<!--
This brings us to a fundamental question: what can we bind to a variable? We
may want to require that an argument of a $\lambda$-expression
has to be reduced as much as possible before it is being bound to a
variable. Or we may say, let any term be bound, and let the reduction 
happen later when we cannot delay it further.
This is, very roughly, the difference of call-by-value vs call-by-name.

Another fundamental question is: how much do we reduce? Specifically,
if we have a $\lambda$ expression, do we keep looking for reducible
expressions? In many applications it is fine to stop reducing when
a term has become a $\lambda$-expression, but when we talk about
normal form of a proof, we want to reach a form where all reductions
have been carried out and no more are possible.
-->

# Values and computations

Instead of defining evaluation contexts separately, we now
look at a different way of impose order on evaluation. 
In doing so, we start treating contexts as computation (filling the hole
with a value is something that can produce a new value). We will see that 
what we are about to do is not very different from specifying an
intermediate representation (IR) of a compiler.

CBPV is a calculus that encompasses both call-by-value and call-by-name.
It achieves this through a fine-grained distinction between terms that are
*values* vs terms that are *computations* which is enfored by a
type disciple. Therefore we will have value types 
$A^+$ and computation types $A^-$:

$$
\begin{array}{lll}
A^- &::= & A^+ \rightarrow B^-\ |\ \uparrow{A^+} \\\\
A^+ &::= &\mathbf{1}\ |\ \downarrow{A^-}
\end{array}
$$

The type operators $\uparrow{}$ and $\downarrow{}$ are described
below. We add $\mathbf{1}$ (the "unit type") as a base type, with 
only inhabitant $\mathtt{()}$
that we pronounce as "unit".
Base types like $\mathtt{Int}$
or $\mathtt{String}$ would also be value types. The arrow type
forces arguments to be of value type and the result to be of
computation type. What matters most is the interplay
of $\lambda$-abstraction and application. 
Here are the typing rules for these:

$$
\begin{prooftree}
\AxiomC{$\Gamma, x: A^+ \vdash s: B^-$}
\RightLabel{$(\to_I)$}
\UnaryInfC{$\Gamma \vdash (\lambda x: A^+. s):\\, A^+ \rightarrow B^-$}
\end{prooftree}
\quad
\quad
\begin{prooftree}
\AxiomC{$\Gamma \vdash s:\\, A^+ \rightarrow B^-$}
\AxiomC{$\Gamma \vdash t:\\, A^+$}
\RightLabel{$(\to_E)$}
\BinaryInfC{$\Gamma \vdash (s\ t):\\, B^-$}
\end{prooftree}
$$

In words, a $\lambda$-expression has an arrow type which is a computation (negative) type.
We can chain abstractions like $\lambda x:X^+. \lambda y:Y^+. s$ for some
term $s$ of computation type, but the argument types $X^+, Y^+$ are forced
to be be value (positive) types. Application yields a computation type.
This is where it may be useful to remember that filling the hole of a context
yields something that we can turn into a value (but it is not a value yet).

You may have noticed the $I$ and $E$ letters in the rule names.
In natural deduction, every logical connective comes
with an introduction and elimination rule. Even though we write
these like sequents of sequent calculus, there are a few differences.
In sequent calculus, there are left- and
right-(introduction)-rules, and a computation step corresponds to 
the removal of detours (lemmas) via cut-elimination. 

### Shifts 

As any type discipline, the above rules make sure that certain programs
cannot be written anymore. 
How can we return a value, though? Or write an identity computation? Or 
pass a function as an argument to another function? Our calculus is
not yet complete.

First, we need a way to turn a value into a computation. More precisely,
we want to turn a term $p: A^+$ of value (positive) type into a term
of computation (negative) type.

Let us call this operation $\mathtt{return}\ p$. This is a "shift" between
value types and computation types and is made
explicit using a type operator $\uparrow\\!{}A^+$. The notation requires
some decoding work since $\uparrow\\!{}A^+$ is a computation (negative) type.

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

The corresponding elimination operation takes a suspended computation and yields 
a value. We use a "$\mathtt{let\ val}$" declaration as source syntax. Note how the type 
discipline forces the righthand-side to be a suspended computation and how this
imposes an order - we need to have the value before continuing. In turning the
the right-hand side into a value, we not only know where the actual computation
happens; we also bind the result to a local name.

This amounts (almost) to all intermediary results being named.

Next, we want to "package" a computation
into a value (*suspend* the computation). This will let us pass a $\lambda$-abstraction
as an argument to another $\lambda$-abstraction. We introduce an operator 
$\mathtt{thunk}\ t$ that suspends a computation and an operator 
$\mathtt{force}\ s$ that resumes a suspended computation.

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

Again, the shift operator indicates in the type that we 
have a suspended computation which is a value. Thus,
$\downarrow$ shifts a negative to a positive type, and
$\downarrow\\!A^-$ can be used in all places that
require a value type.

### Example programs

Let's look at examples, starting with the identity combinator
of plain $\lambda$-calculus. We want one of these at every type $I_A := \lambda x: A. x$ of type
$A \rightarrow A$. In the above polarized $\lambda$-calculus,
we get something close enough:

* for value types, there is: $\mathit{idval}_{A^+} := \lambda x: A^+. \mathtt{return}\\,x$
* for computation types, we have: $\mathit{idcmp}_{A^-} := \lambda x:\\,\downarrow{A^-}. \mathtt{force}\ x$

(Exercise: what are the types of these? What kind of "optimization" would remove these?)

<!-- By looking at the rules, we can verify that this has type $A^+ \rightarrow\\,\uparrow\\!{}A^+$. -->

<!--
If we want to pass a computation requires suspending it via $\mathtt{thunk}\ \mathit{id}$. This
is the only way to turn it into a value type  $\downarrow(A^+ \rightarrow\\,\uparrow\\!{}A^+)$.
-->

Next, let us try a combinator $\mathit{twice}_A$ of type $(A \rightarrow A) \rightarrow A \rightarrow A$.
It takes a function $f$ and and argument $x$ and applies $f$ to $x$ twice.
In our polarized $\lambda$ calculus, we need to use the other shift
operation and end up with: 
<!-- a term of type $\downarrow(A^+ \rightarrow\\,\uparrow\\!{}A^+) \rightarrow A^+ \rightarrow\\,\uparrow\\!A^-$: -->

<!--
$$\lambda f:\\~\\~\downarrow(A^+ \rightarrow\\, \uparrow\\!A^+). \lambda x:A^+.\ \ldots(\mathrm{exercise!})\ldots$$
-->

$$
\begin{array}{l}
\lambda f:\\,\downarrow(A^+ \rightarrow\\, \uparrow\\!A^+). \lambda x:A^+. \\\\
\mathtt{let\ val}\ y\ =\ (\mathtt{force}\ f)\ x\ \mathtt{in} \\\\ 
(\mathtt{force}\ f)\ y
\end{array}
$$

Note how the intermediary result has a name $y$. (Exercise: what is the type
of this program? If we used an alternative term which didn't use $\mathbf{return}$, what
changes?)

# An interpreter

<!--
The let declaration in rule $(\uparrow_E)$ is not merely a convenience for 
local declarations, it is a load-bearing construct of the calculus. In the CBPV book,
it is written $e_1\ \mathtt{to}\ x.\ e_2$. It is very clear that
$e_1$ has to be evaluated and bound to $x$ before any evaluation work
on $e_2$ can begin.

What is maybe less obvious is that instead of the high-level
substitution operation, we only bind and lookup variables. In
particular, there are never any name clashes.
-->

The logical reading of these typing rules is that we have set up a particular kind
of natural deduction calculus. A term that has a type derivation is a proof, and an
introduction followed by an elimitation is clearly a "detour".
These detours can be removed and these proof normalization steps
correspond to computation steps.


<!--
$$ \mathtt{let\ val}\ x = \mathtt{return}\ s\ \mathtt{in}\ t \longrightarrow_\beta t[x\leftarrow s]$$
$$ \mathtt{force}\ (\mathtt{thunk}\ t) \longrightarrow_\beta t $$
-->

At this point, we can write out local reductions:

$$\begin{array}{ll}
\mathtt{let\ val}\ x\ =\ \mathtt{return}\ v\ \mathtt{in} \mathtt{t} &\rightsquigarrow t[x := v] \\\\
\mathtt{thunk}\ (\mathtt{force}\ t) &\rightsquigarrow t
\end{array}
$$

This is not what we were after though. Instead, we can define an *abstract machine*
that specifies exactly which rewriting steps to take when. What is special about
an abstract machine is that unlike an interpreter that recursively traverses
an expression, the machine always operates at a bounded depth from the top.

What follows are transitions rules of a CK machine. Here C stands for control and K is a stack of
contexts. 
The source level $\mathbf{let\ val}\ x\ = \\_ \ \mathbf{in}\ t$ expression is shortened to $(\\_ \ \mathtt{to}\ x. t)$,
and an application where we are waiting for the operator to be evaluated is written $(\\\_\ v)$.
This gives a simple operational semantics, although a CK machine is still a rather high-level description since
we need to appeal to substitution in the definition.

$$
\begin{array}{llll}
C                                        & K & \rightsquigarrow & C' & K' \\\\
\mathtt{let\ val}\ x = s\ \mathtt{in}\ t & k &                 & s  & (\\\_ \ \mathtt{to}\ x. t) :: k \\\\
\mathtt{return}\ v                       & (\\_\ \mathtt{to}\ x. t) :: k & & t[x := v] &  k  \\\\
\mathtt{force} (\mathtt{thunk}\ t)       & k   &   & t   &  k \\\\
s\ v                                     & k   &   & s   & (\\\_ \ v) :: k \\\\
\lambda x. t & (\\\_ \ v) :: k & & t[x := v] & k
\end{array}
$$

There is a simple idea behind all this which is worth restating: we statically (through the type system) know 
that every application $(s\ v)$ comes with an operand that is a value. So:
- whenever we evaluate an application we start by pushing a value
- when we are done with evaluating operator and have a $\lambda$-term, we pop the value

More precisely, what we push and pop is an application context with a value as operand.
Even though this looks like call-by-value, this subsumes call-by-name because a suspended computation
can be treated as a value. The stack is a list of nested contexts. In a sense,
it is dual to an expression; this can be made precise but we won't do this now.

# A preview of the continuation 

We started from a natural deduction calculus, which is used for formal logical reasoning, and ended up with an abstract machine.
Unlike rewriting, we have made a step towards a more mechanical, low-level way of normalizing expressions. The fact that the
CK machine is still using substitutions makes it look like we are playing a formal game of symbol manipulation, but if
we could continue from here towards a CEK machine which replaces substitutions with environments.

On the logical side, since we did not discuss products and sums, we are missing conjunction and disjunction. We did not
discuss polarization much. We did not explore classical reasoning, negation, sequent calculus.

We did not talk about effects yet. CBPV gives us a handle on computational effects, similar to monads but different.
It should be obvious how a lean way to specifying evaluation order helps with describing effects.

This is a good time to pause and reflect, before we go to the next round and shed light on some of these topics. In
the meantime, here are some pointers to learn more:

* Frank Pfenning's 2016 [lecture notes on substructual logic](https://www.cs.cmu.edu/~fp/courses/15816-f16/schedule.html) has a chapter on CBPV.
It ends not with a CK machine, but a specification of operational semantics in an ordered logic
formalism.
* CBPV is described in the book "Call-by-Push-Value: A Functional Imperative Synthesis" by Paul Blain Levy. A minor difference is that
we spell out the application context with the value here while in Levy's stack only the value gets pushed.
* Matthias Felleisen's [lecture notes](https://felleisen.org/matthias/4400-s20/lecture23.html) have a discussion of CK, CEK, CESK machines.
The introduction of environments lets us get rid of substitutions and replace them with environment lookups. This is not yet an
efficient language implementation, but it closes the gap. There is discussion about treating the environment more like a call stack, including
popping unused values. And (for the CESK) there is a discussion on allocating structures.
* Bob Harper's post on [polarity in type theory](https://existentialtype.wordpress.com/2012/08/25/polarity-in-type-theory/)
* Zena M. Ariola, Aaron Bohannon, Amr Sabry. [Sequent calculi and abstract machines](https://legacy.cs.indiana.edu/~sabry/papers/sequent.pdf) has a
thorough discussion of natural deduction.
* Nick Benton, Gavin Bierman, Valeria de Paiva, Martin Hyland. [Term Assignment for Intuitionistic Linear Logic](https://www.researchgate.net/publication/2648556_Term_Assignment_for_Intuitionistic_Linear_Logic_Preliminary_Report)

<!--
Natural deduction as introduced by Gentzen has a normalization theorem: a proof derivation
can be rewritten in a way that it contains no detours. This result is analogous to
cut-elimination result for sequent calculus, but the correspondence is subtle. While
in sequent calculus, we interpret the cut-rule as computation steps, in natural deduction
we have local reductions.

We could also have predefined constants like $\mathtt{plus}: Int^+ \rightarrow Int^+ \rightarrow Int^-$.

Since we are talking about programs, we want to compose computations, that is, build larger computations out of smaller ones.
-->
