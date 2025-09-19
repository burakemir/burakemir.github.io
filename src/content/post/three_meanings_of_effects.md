+++
title = "Three meanings of Effects"
date = 2025-09-19
[taxonomies]
categories = ["blog"]
tags = ["effects", "types", "memory safety"]
[extra]
math = true
+++

In the programming languages discourse, the word "effect" is used with different meanings.

This can lead to confusion. In research, it is difficult to avoid jargon, but it
comes at the price of making it more difficult to make sense of interconnected meanings
programming language concepts. 

Effects - in more than one sense - are interesting today. The software industry is gearing up 
to move its system programming artifacts from a dark swamp of legacy
into the flushing green meadows of *memory safety*.
I argue between the lines of [Memory Safety - the missing definition](memory_safety_the_missing_def), 
programming language design is the source and cause of all memory safety problems.
Maybe effects can help turn it into a solution.

In the following, I will establish a baseline and then enumerate the three specialized meanings for "effects":

* Type and Effect Systems
* Notions-of-Computation Effects
* Effect Handlers (Algebraic Effects)

I am not aware of others meanings. The TL;DR is that type and effect systems come from a 
very different tradition than computational effects and effect handlers. 

This is not merely a terminology discussion, but an analytical effort fishing deep in semantics and 
pragmatics territory. Before we take the plunge, we have to establish a baseline, though.

## Side Effects

Imperative programming is about manipulation of state (memory, IO, ...) through a sequence of commands.
Choosing this way to program has consequences on our ability to define a *static semantics*.

By static semantics, we mean a type system that determines which programs we consider valid.
This enable us to reason about properties of programs without having to run them.

Imperative programs are composed of "functions" (really: procedures). 
We may assign a type to a function to describe inputs and output. This type does not contain 
any information about the state manipulation. Picturing a function as a form or
transformation from input to output, the have been called **side effects**.

These functions are not mathematical functions, even if mathematics is what led to computers
and "computation". It is tempting to go on a philosophical tangent on [epistemology](https://bq9.blogspot.com/2020/07/language-logic-and-modeling.html)
now, but we will refrain from doing so.

One often encounters "pure" as an adjective for functions that do not have side-effects. 
This is as if side effects taint the purity of mathematics, and indeed formal reasoning
becomes harder in languages with side effects (evaluation order matters). Is it possible
to define a static semantics that retains essential information?

Type systems are the most widespread and effective way to get static semantics. They are
a special form of static analysis that is built into the programming language design.
So why not add effects to type system and track more information that way?

## Type and Effect System

A type and effect system is just that: the enrichment of types with annotations.

The first effect system (Lucassen, Gifford. "Polymorphic Effect Systems") was about memory access. It
tracked read, write to a region of memory, in 1988.

Nielson and Nielson give a wonderful, timeless description in ["Type and Effect Systems"](https://web.cs.ucla.edu/~palsberg/tba/papers/nielson-nielson-csd99.pdf), from 1999.
The wikipedia page ["Effect system"](https://en.wikipedia.org/wiki/Effect_system) is very congruent with that.
This is a good place to remark that in industry it is at present entirely normal that decades pass before ideas
from research get taken up.

Time for a brief example: imagine we have a toy imperative programming language with a built-in `print`
command. We can define a `print` effect and tag function types. Thus we gained the ability to
distinguish between functions that print and functions that don't print. This would give us ways
to enforce a *type discipline* where certain operations can take functions that are not permitted
to print anything. We can immediately see that we then also need to think about propagating effect 
information (effect-polymorphism).

Our mere decision to be tracking effects in the type system leads to more questions: which effects should
we track? And what should we check?

So it is very easy to state that something is (or should be) an effect. Whether that is valuable
has to be demonstrated by the rules that make use of the effect information. The proof of the
pudding is in the eating.

Modern programming languages give programmers various ways to "extend the language": user-defined data types
and operations (bundled as classes in OOP), only providing built-in operations (primitives) for
IO, memory allocation. A challenge in type and effect systems outside of minimal research languages
is how these facilities for user-defined constructs should be combined with effects. In
particular, *abstraction* depends on the ability to hide information.

## Notions of Computation

We now shift our perspective completely and embrace functional programming view.
Away with side effects.

Researchers who study programming languages (PL) have a need to describe 
PL concepts and semantics formally. Many mathematical and logical 
characterizations have entered the discourse on programming, for example
"boolean", "set", "map". 

A particular mathematical field that stands out is category theory. Don't run away yet!
It is a language for making precise statements about structure-preserving 
transformations. The goal is to learn about the structures by studying the transformations.

In PL theory, one constantly needs to talk about structures (concepts) that exist across 
different PLs, or can be expressed in many different ways. And thus, product types, 
sum types (co-product), co- and contravariance and functors found their way into PL discourse. 
The connection to category theory is often lost in the process, but that has not 
led to significant problems so far.

The $\lambda$-calculus has been used as a vehicle for PL research.  Its basic unit 
computation step (substitution) lends itself so well for compositionality and formal reasoning,
giving rise to functional programming.

Taking inspiration from mathematics, researchers have enjoyed giving *meaning* to
programs by assigning mathematical structures (denotational semantics), the
idea being that these are widely understood, or understandable. In this
vein, a $\lambda$-term would ultimately correspond to a mathematical function of some 
kind.

In his 1991 article "Computational lambda-calculus and monads", Eugenio Moggi 
challenged the idea that semantics of $\lambda$-terms should correspond to
simple mathematical functions. He pointed out the existence of various firmly
established *notions of computation* which are all better explained by something else,
and this would pave the way to reason about program equivalence logically.

We will not explain monads here, but just the particular "notions of computation" view.
It turns out to not be that difficult. In the context of programming, monads are 
about program composition.

### Types and Algebra

Today (!) all programmers understand the concept of a generic type. For instance,
we can make sense of the phrase "a type $List[T]$ is a list whose elements are of type $T$".
Let's call $List$ a type constructor.

A type constructor with a single argument $F[T]$ could be considered an operation that takes
a type and returns a type. Other operations that constructing types are $\times$ for product
types and $+$ for sum types, and 1 for unit (a type that holds no information), and 0 for
a type that has no members. Types built from $\times$, $+$, 1 and 0 can be called algebraic
types because they look like terms we use in high school algebra.

Now, we need to make a mental step away from given programming language, into a
world where instead of *types* talking about specific values in a given language, 
we have *types* that talk about all semantics. Semantics go beyond all the values
that may occur in a given a language, we also have to give meaning to the operations.

The insight, then, is this: suppose we have a $T$ that represents all semantic values
of our programming language, we can think of a "semantic type constructor" $F$ that transform 
it into a mathematical structure that very accurately describes a notion of computation:

* $F[T] = 1 + T$ partial computation: either returns a result $T$ or nothing.
* $F[T] = List[T]$ non determinism: returns a whole list (or set) of results.
* $F[T] = S \times T$ stateful computation: operations may read and modify a state $S$

One can think of others.  When we see this, we can say $F$ captures the 
computational effects of the operations given in such a notion of computation.

The "monad" part comes in when we talk about composing program fragments from building blocks.
As promised, we will not go into the monad laws and join,unit,bind operations here.
It is enough to say: when we focus on the way programs are composed / sequences, we end
up with an abstract framework for reasoning about programs with effects.

This turns out to be super-useful for practical programming. This approach lets us
define our own programming language inside a given programming language. And what's
more, we can see embedded "languages" (programs composed from commands) in this way
even if the people who built them never heard about monads.

### Effects in Functional Programming

This is the place to mention Haskell, where the main function of every program
is a computation in the IO monad. Over the years, people have taken up this
approach in many languages. They:

* use type constructors in their favorite language to structure their programs to implement domain-specific languages
* started to call the $F$ itself a "computational effect"
* write lots of monad tutorials

And this has some justification, because it is useful to define data types and operations
that act as domain-specific languages (the "Interpreter" design pattern, anyone?). 

What if I told you that `async` is an effect? As we know, a widespread way to implement
`async` functions is to transform them into normal functions that return a `Future<T>`.
`Future` is a unary type constructor and we can come up with rules of composing such functions.

I think it is fair to say that the vast majority of programmers will not bother to ask whether monad axioms hold,
presumably because the vast majority of programmers will never have the time and
energy to learn category theory. So using "effect" as a hand-wavy replacement for monad
can certainly be seen in the wild, and we can see the use of it.

And what if we want a partial computation returns an error? `Result<T, E> = T + E` gives
us the same ways to compose, even if it is not unary type constructor. This is pretty
useful, and we seem not really bothered by the fact that `Result` takes two type
arguments instead of one. This is because in practice, programmers use monads as an
"abstraction pattern", **mutatis mutandis**, and the transformations that would
be enabled by adherence to monad laws are less of a concern.

## Control Effects and Effect handlers

We can see that manipulating memory may be a good candidate for effect tracking, but the print
example shows that we can also single out specific operations and consider these as effects.

What if we committed to a world of user-definable effects? This is where "algebraic effects" and
control flow come in. Control flow is one of the many area where programming language research
is looking for something better than mere function calls and for-loops. Consider the
ability to suspend computation or return through multiple paths and multiple approaches to
package that like exceptions, coroutines, iterators, generators and async functions.

The "algebraic" comes in when we consider a user-definable operation and effect, and that
operation takes parameters. I will not try to get into definitions but just point
to the excellent ["Effekt" research programming language](https://effekt-lang.org/#intro-handlers) 
where everything is explained pretty well.

In particular, a type and effect system is used to check whether the (user-defined) effects
are handled. Here, the multiple meanings hit us with full force, the effects - annotations on types - that
are being tracked are effects, as in user-defined operations that can be interleave with
normal control flow.

Effect handlers combine both, the type and effect approach which could be used for tracking
many things, and the notions-of-computation effects which specifically refer to composition.

# The End

There are multiple deep connections between category and programming language technology.
It is absolutely remarkable what monads can do programming language semantics. We
were able to talk about concepts that appear in so many languages, like professional
programming language designers. And we did not need all that much jargon.

Monads are the realm of theory, a "meta programming language" concept. This is a 
completely different game from giving users a way to define their own programming 
language operations, which is about expressiveness and pragmatics. This level mismatch
is the source of confusion; sometimes we need our boxes so we are able to think outside of them.

I hope this post helped establish a clearer idea how the venerable idea of type and effect 
systems, the venerable idea of notions-of-computation and how they get combined in
the **tr&egrave;s en vogue** algebraic effects trend in research.

May it help us synthesize the good ideas of the past and forge a better future.
