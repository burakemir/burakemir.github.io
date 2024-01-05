+++
title = "CEK and Control Operators"
date = 2024-01-05
[taxonomies]
categories = ["blog"]
tags = ["abstract machine"]
[extra]
math = true
+++
Today is a good day to recall some foundations of formal abstract machines, continuations, control and data stacks.
And a good place to place to start is the CEK machine, described in Felleisen and Friedman's 1986 paper
"[Control operators, the SECD machine and the $\lambda$ calculus.](https://legacy.cs.indiana.edu/ftp/techreports/TR197.pdf)"  and
Felleisen's 1987 [dissertation](https://www2.ccs.neu.edu/racket/pubs/dissertation-felleisen.pdf).

An *abstract machine* is a device and method for formally specifying program semantics: we define
the meaning of a program by describing a state machine that obtains a result. In other words,
we are defining the meaning by providing a particular kind of interpreter. This should be fun!

An abstract machine does not have instructions but operates on *terms*. This makes
abstract machines different from processors or virtual machines. Terms (abstract syntax) are a high-level, formal
representation of a program that fully captures its essence.

We will work with a simple $\lambda$-calculus. Formally, $\lambda$-calculus is a rewriting 
system and the basic question (word problem) consists of deciding whether two terms are equivalent. We want
to come up with a mechanical way of simplifying the terms by applying $\beta$ reduction:

$$ (\lambda x. M) N \longrightarrow_\beta M [x := N] \ $$

The $\lambda$ calculus is minimalistic but it can nevertheless be used to express all concepts in programming languages.
Felleisen's work from that time deals with storage and assignment, too (the CESK machine), but we will not do that here.
In order to simplify the exposition, we also defer the discussion of control operators $\mathcal{C}$ or $\mathcal{A}$ 

## Call-by-value evaluation

Let's start with syntax:

$$ M, N ::= x\ |\ \lambda x. M\ |\ M N\ $$
<!-- next: Bierman a computational interpretation of lambda-mu calculus -->

A term is either a variable, a $\lambda$-abstraction or an application. In an application $M N$, let's call $M$ the 
"function" term and $N$ the "argument" term. We ought to discuss free and bound variables, the pitfalls and
conventions to avoid them, but we omit this. 

As mentioned, a computation step is a $\beta$ reduction. Specifically, reduction happens in application terms 
where the function is a $\lambda$ abstraction.
So far this leaves unspecified in which order we should reduce application terms and also what 
kind of values can be bound to $x$.  We want to fix that and clarify that we want a variable to be bound
to *values* $V$, by which we mean $\lambda$-expression that cannot be reduced further,
and that we do not reduce *under* a $\lambda$-abstraction.

A way to make this precise is to define *evaluation contexts*. We describe precisely where an evaluation step
can take place and write that particular location as $[~ ]$.

$$ {\color{lightgreen}C[~ ]}\ ::= [~ ]\ |\ {\color{lightgreen}C[~ ]}\\ N\ |\ V\ {\color{\lightgreen}C[~ ]}\\ $$

In other words, we are looking for the innermost application term, and we reduce the function term before we reduce the argument term.

It is now interesting and essential to see that an evaluation context ${\color{\lightgreen}C[~ ]}$ can be split up 
into multiple *frames* which we can arranged as a list (stack) to recover the original context: 

$$ \mathrm{Fr} ::= [~ ]\ |\ [~ ] N\ |\ V [~ ] $$

When descending into an evaluation context, we turn each level into a frame and
put it on a stack. For the other direction, we take a stack of frames and plug each frame into the next one to obtain
the original evaluation context.  For example, writing $::$ as separator and having stacks grow to the left, the evaluation
context $V_1 (V_2 (([] N)))$ becomes $[\~] :: ([\~] N) :: (V_2 [\~]) :: (V_1 [\~])$.

## Continuations

The key idea now is this: since frames are particular points in the term, we can associate these
points with a bit of data that specifies what our abstract machine should do next. The data
we need to keep track of are *semantic values* $V$ which are the results of evaluating 
expressions and *environments* $\rho$ which map variables to semantic values. An 
empty environment is written $\emptyset$ and extending an environment $\rho$ with
a binding $x:=V$ is written $[x := V]\rho$

For now, the only kind of semantic value we can have will be a *closure*, that is, 
a pair $\langle M, \rho\rangle$ of an abstraction $M$ and an environment $\rho$
that captures assignments for the free variables that might occur. So for
example, a $(\lambda x. \lambda y. x y) (\lambda z.z)$ can be evaluated to
$\langle \lambda y. x y, [ x := (\lambda z.z) ]\rangle$ 


Let us call the frame annotated with the data *continuation points* and write them down. 

$$ \kappa ::= \mathtt{stop}\ |\ \mathtt{arg}~N\ \rho :: \kappa\ |\ \mathtt{fun}~V :: \kappa $$

The definition reads like the definition of a stack (the data structure) that grows to the left.
Compare this to the definition of frames $\mathrm{Fr}$. We do not have a need to represent $[~]$,
but we do want to represent the empty stack. We have:

* $\mathtt{stop}$ for the empty stack,
* a case $\mathtt{arg}\~N\~\rho$ for evaluating an argument in environment $\rho$ and 
* a case $\mathtt{fun}~V$ that represents an evaluated function term $V$ waiting for its argument.

We need one more case for returning the result of evaluation. We write this as $\mathtt{ret}\ V$
and note that it can only occur at the top of the stack: 

$$ K = \mathtt{ret}\ V :: \kappa\ | \ \kappa $$


<!--
$$
\begin{array}{ll}
x & x \in \mathsf{Var} \\\\
\lambda x. M & \\\\
M N & \\\\
\mathcal{C} M & \\\\
\mathcal{A} M & \\\\
\end{array}
$$
-->

<!--
$$
\begin{array}{ll}
[~ ] & \\\\
[~ ] N & \\\\
V [~ ] & \\\\
\mathcal{C} [~ ] & \\\\
\mathcal{A} [~ ] & \\\\
\end{array}
$$
-->

The CEK machine has a control register C, and environment $\rho$, and a stack K. Together, these
three registers form the state. The control register can be empty which we write as $\updownarrow$ or contain
a term $M$. The rules are as follows:

$$
\begin{array}{lllllll}
\langle x, &\rho, &\kappa \rangle &\longrightarrow &\langle \updownarrow, &\emptyset, &\mathtt{ret}~ \rho(x) :: \kappa\rangle \\\\
\langle \lambda x.M, &\rho, &\kappa \rangle &\longrightarrow &\langle \updownarrow, &\emptyset, &\mathtt{ret}~ \langle\lambda x.M, \rho\rangle :: \kappa \rangle \\\\
\langle M N, &\rho, &\kappa \rangle  &\longrightarrow &\langle M, &\rho, &\mathtt{arg}~ N~ \rho :: \kappa \rangle \\\\
\langle \updownarrow, &\emptyset, &\mathtt{ret} V :: \mathtt{arg} N \rho :: \kappa \rangle  &\longrightarrow &\langle N, &\rho, &\mathtt{fun}~ V :: \kappa \rangle \\\\
\langle \updownarrow, &\emptyset, &\mathtt{ret} V :: \mathtt{fun} \langle\lambda x. M, \rho\rangle :: \kappa \rangle  &\longrightarrow &\langle M, &[x := V]\rho, &\kappa \rangle \\\\
\end{array}
$$

In order to complete the definition we should talk about "loading" $\lambda$-expressions into the machine, let it 
perform transitions until it is done, then "unloading" the result.
* Loading $M$ means setting the initial state to $\langle M, \emptyset, \mathtt{stop}\rangle$
* The terminal state should look like $\langle \updownarrow, \emptyset, \mathtt{ret} V :: \mathtt{stop}\rangle$. From
this, we can unload $V$.

There are terms that will make the machine loop. For a closed term $M$, if the machine terminates, it will end
up in a terminal state and we should be able to unload. Therefore we can define a partial function $eval_{CEK}$
which loads a term $M$, applies transitions, and if it ends up in a terminal state, returns $V$. One can
then prove that if $eval_{CEK} (M) = V$ then $M \longrightarrow^* V$.

## Control operators

What if we went further in our approach of adding data to our stack frames? Suppose, our semantic values
were not only closures but could also capture continuations (stacks). Then we could restore them and
get a notion of "jumping". We add two control operators ${\color{lightgreen}\mathcal{C}}$ and
${\color{lightgreen}\mathcal{A}}$:

$$ M, N ::= x\ |\ \lambda x. M\ |\ M N\ |\ {\color{lightgreen}\mathcal{C}} M\ |\ {\color{lightgreen}\mathcal{A}} M $$

We skip evaluation context and jump straight to frames:

$$ \mathrm{Fr} ::= [~ ]\ |\ [~ ] N\ |\ V [~ ]\ |\ {\color{lightgreen}\mathcal{C}} [~ ]\ |\ {\color{lightgreen}\mathcal{A}} [~ ] $$

Our continuations is almost the same, but gets a continuation marker:

$$ \kappa ::= \mathtt{stop}\ |\ {\color{lightgreen}\mathtt{cont}} :: \kappa\ |\ \mathtt{arg} N \rho :: \kappa\ |\ \mathtt{fun} V :: \kappa $$

Our semantic values $V$ can now either be closures or p-continuations $\langle{\color{lightblue}\mathtt{p}}, \kappa\rangle$.
With this, we can now add additional transitions for the control operators:

$$
\begin{array}{lllllll}
\langle {\color{lightgreen}\mathcal{C}} M, &\rho, &\kappa \rangle &\longrightarrow &\langle M, &\rho, &{\color{lightgreen}\mathtt{cont}} :: \kappa\rangle \\\\
\langle \updownarrow, &\emptyset, &\mathtt{ret} \langle\lambda x. M, \rho\rangle :: {\color{lightgreen}\mathtt{cont}} :: \kappa \rangle  &\longrightarrow &\langle M, &[x := \langle{\color{lightblue}\mathtt{p}}, \kappa\rangle]\rho, &\mathtt{stop} \rangle \\\\
\langle \updownarrow, &\emptyset, &\mathtt{ret} \langle{\color{lightblue}\mathtt{p}}, \kappa_0 \rangle :: {\color{lightgreen}\mathtt{cont}} :: \kappa \rangle  &\longrightarrow & \langle \updownarrow, &\emptyset, &\mathtt{ret}\langle{\color{lightblue}\mathtt{p}}, \kappa\rangle :: \kappa_0 \rangle \\\\
\langle \updownarrow, &\emptyset, &\mathtt{ret}~V :: \mathtt{fun} \langle{\color{lightblue}\mathtt{p}}, \kappa_0 \rangle :: \kappa \rangle  &\longrightarrow & \langle \updownarrow, &\emptyset, &\mathtt{ret}~V:: \kappa_0 \rangle \\\\
\langle {\color{lightgreen}\mathcal{A}} M, &\rho, &\kappa \rangle  &\longrightarrow & \langle M, &\rho, &\mathtt{stop} \rangle \\\\
\end{array}
$$

I am not going to reproduce the entire paper. It includes the CK machine (which substitutes eagerly, instead
of putting bindings into an environment). This is useful for proving properties, but substitution is something
that is avoided in actual implementations.  The paper goes on to obtain a calculus (via the CC machine and the
C rewriting system) which is proven equivalent to the CEK machine semantics (with control operators).

## stop: the empty stack

What I wanted for now: a self-contained description of the CEK, a call-by-value abstract machine. When we strip
away the discussion of control operators, we can see the beautifully simple idea that capturing "what needs to
be done next" in a control stack.

The stack is very much a control stack: while is has some data, this data is for the machine itself. The actual argument
passing happens in the environment. The environment however, is not actually a stack: it is captured in closures
and extended at different times so it looks more like a tree. You can read a bit more in 
Principles of Programming Languages [lecture notes](https://felleisen.org/matthias/4400-s20/lecture23.html) which
also extend the CEK wth storage, which yields the CESK.

Abstract machines correspond closely to evaluators via transform to continuation passing style. There are many papers about this. 
Ager, Biernacki, Danvy and Midtgaard [A Functional Correspondence between Evaluators and Abstract Machines](https://www.brics.dk/RS/03/13/BRICS-RS-03-13.pdf)

Abstract machines have been used correct in programming language implementations. The challenge is in
representing environments efficiently: a closure may not need to access the *entire* environment.
There is a nice discussion about the role of abstract machines for PL implementations in Xavier Leroy's talk ["From Krivine's machine to the Caml implementations"](https://xavierleroy.org/talks/zam-kazam05.pdf). A properly efficient 
implementation would translate to machine code, using registers or generally
any calling convention, but if one does use an abstract machine, one cab make it better by applying techniques
such as push arguments on the stack as a way to access them faster.


