+++
title = "CBPV and Natural Deduction - Part 4. Polarized Logic"
date = 2023-09-16
[taxonomies]
categories = ["blog"]
tags = ["logic", "abstract machine", "cbpv"]
[extra]
math = true
+++

This is the last and final part of my little study of polarized
natural deduction by means of CBPV. The previous parts are 
 ["pt1. small steps"](@/post/cbpv_pt1_small_steps.md), 
 ["pt2. sums and products"](@/post/cbpv_pt2_sum_product.md), and
 ["pt3. linear logic"](@/post/cbpv_pt3_linear_logic.md).

In this part, I will sum up what I find this interesting. This is
going to be a bit more personal/opinionated/colored than the previous
parts.

## Proof-theoretical semantics

CBPV as polarized natural deduction helps develop an intuition for "proof-theoretical semantics."

It may be a subjective preference, but I consider intuition important.
I believe that in the ideal world, intuition, "explanatory power" and
teachability would play a role that has weight equal or greater than
"new results" of research. This is clearly not the world we
live in, but we can nevertheless asipre.

So let me draw a rough "baseline" of logic, computation and programming languages.

* Natural deduction (not sequent calculus) is the standard notation for
discussing formal reasoning, proof, structural and substructural proof theory. 
It goes back to Jaskowski and Gentzen, but today, two people deserve special mention:

   * Dag Prawitz for picking up proof-theoretic semantics and natural 
     deduction, providing a normalization theorem for natural deduction
     calculi

   * Per Martin-L&ouml;f for basing his presentation of [intuitionistic type
     theory](https://archive-pml.github.io/martin-lof/pdfs/Bibliopolis-Book-retypeset-1984.pdf) on the natural deduction style and establishing the concept of 
     judgment.

* Type systems are presented as natural deduction calculi (with "localized assumptions", so a judgment looks like a sequent of sequent calculus). Type systems provide the most effective form of mechanized reasoning and program analysis
that we have in programming languages. 
<!--This is not even
mentioning the advantages for documentation, IDE support, modularity
and separate compilation. In the Curry-Howard perspective, type-checking is 
a strangely backwards operation where we have a proof and are looking
for the proposition it is proving.
-->

* Sequent calculus is the device used in more formal studies of reasoning, 
structured and substructual proof. When we use sequent calculus, we
accept a greater distance to intuition and "informal reasoning" for
technical reasons. Automated reasoning using "semantic tableaux" is
essentially the same as working with sequent calculus.

   * In [Proofs and Types](https://www.paultaylor.eu/stable/prot.pdf), Jean-Yves Girard argues that sequent calculus is "the prettiest illustration of
the symmetries of Logic", and that it was "generally ignored by computer scientists." This may have been true at the time, but it is certainly no longer the case.

   * Samson Abramsky does give the sequent calculus its deserved treatment
in [Computational interpretations of linear logic](https://www.sciencedirect.com/science/article/pii/030439759390181R), though Girard may not have had an operational reading in mind. Abramsky describes a symmetry between
constructors (right rules, introduction rules) and destructors (left rules,
elimination rules) which gives a proof-theoretic explanation on
insights that go back to the McCarthy and Landin.

## Focusing and uniform proofs

Now that we have established a (possibly subjective) baseline, let's talk
about focusing. Focusing makes it appearance in logic programming: here 
computation is not proof normalization, but proof **search**.
   * Dale Miller, Gopalan Nadathur, Frank Pfenning and Andre Scredrov. "Uniform proofs as the foundation for logic programming". Annals of Pure and Applied Logic. 51:125-157, 1991
   * Around roughly the same time, Jean-Marc Andreoli published "Logic programming with focusing proofs in linear logic.". Journal of Logic and Computation. 2(3):197-347 

Focusing is a **structuring principle** for proofs. It is a way to eliminate
the redundancy that is introduced when passing from natural deduction to
sequent calculus (Pfennings [lectures notes](https://www.cs.cmu.edu/~fp/courses/oregon-m10/04-focusing.pdf)). Girard was aware of
Andreoli's work and referenced it "On the unity of logic", introducing
"positive" and "negative" polarity as concepts.

The key idea is that if a rule of inference is **invertible**, it makes sense to
apply it directly and not look for other rules. When invertible rules
have priority over others, this reduces the large search space of proofs.

**Polarized focusing** goes further: in the context of proof search is about "combining
runs of connectives that are positive or negative, with explicit coercions
between runs. These coercions, written $\uparrow$ and $\downarrow$ are
called *shift operators*." (Pfenning, ibid.) This is what we discussed
in this series.

<!--
## Applications of Linear Logic
* After pt3, I prepared a talk ["Call-by-push-value" and ownership](https://burakemir.ch/odersky-fest-23/) where I shared my intention to apply some of this 
content to formalize a part of Rust's type system.

  * In short, it has been known for a long time that linear/affine types 
and substructural logic can be used to model resource management. The
wikipedia article on 
[Bunched logic](https://en.wikipedia.org/wiki/Bunched_logic#Applications)
mentions John C. Reynolds using an affine type theory in 1978. This is
a whopping 9 years before Girard published "linear logic".

  * This is not the place to discuss details neither the subtleties how the 
"no duplication" linearity constraints is part of such substructural logics
nor what part of Rust's types system actually matches the "no duplication"
of linear logic. However, I found out that (besides Phil Wadler's numerous
papers on linear logic), Martin Oderky published a little-known paper on 
"observers for linear logic" which describes read-only access to linear
types as useful in programming, and which is very close to the short-lived, 
immutable, shared references we call "borrows" today.
     * The "lifetime parameters" are what research calls "region variables" and I think Tofte &amp; Talpin's "region-based memory management" may be a good
best reference (it is at least what I learnt in grad school). Lots of
people researched regions afterwards.



https://en.wikipedia.org/wiki/Bunched_logic#Applications
 in types ing resources like memory. I am talking the 1970s.
John C. Reynolds in 1978 (via wikipedia)
There are
more and related approaches, such as Tofte &amp; Talpin's "region-based memory
management", uniqueness types and more recent paper by Guillaume
Munch-Maccagnoni ["Resource Polymorphism"](https://arxiv.org/abs/1803.02796)
which discusses the use even in a garbage-collected language.


 for the [OderskyFest 2023](https://burakemir.ch/odersky-fest-23/)

# Rewind: Logic and Computation

I want to start with a few big picture thoughts what keeps on bringing
me back to logic.

am gathering some thoughts on why polarity and focusing
holds promise towards identifying "fundamental" concepts in programming language research.
Even without the Curry-Howard perspective and logic, distinguishing between
data and computation makes immediate sense. Can we get our formal systems
to reflect this intuition?
-->

## What just happened?

We saw how call-by-push-value (CBPV) "separates" typed $\lambda$-calculus
into *value types* and *computation types*. We obtain a type system which can be
viewed as a natural deduction calculus. This view may seem slightly forced, since
operations like $\mathtt{thunk}$ and $\mathtt{force}$ that control evalution
do not seem very logical. But there are compelling reasons to have them!

If we consider the treatment of inference and assumptions in linear
logic, the familiar operators $\vee, \wedge$ separate into additive
versions $\oplus, \\&$ as well as multiplicate versions  &#x214b; $\otimes$.

Some of these types $\oplus, \otimes$ look like data type constructors,
and we called these positive or value types. For the others  &#x214b; $\\&$.
evaluation does not proceed until the environment demands it. These are
negative or computation types.

* Going back to Bob Harper's post [polarity in type theory](https://existentialtype.wordpress.com/2012/08/25/polarity-in-type-theory/): positive types come 
with a *single* elimination rules which describe how the proof makes
sense of the constituent(s) of the proposition. The connective is
**inductively defined** in the sense that the introduction rule
completely determines what the elimination rule does. It "writes itself".

* On the other hand, negative types come with elimination rules that 
determine what the proofs are going to look like. They are **coinductively
defined** in the sense that "there is no commitment to the internal
structure of a proof", anything that provides a way to apply
elimination rules is acceptable. These may be called "lazy types",
computation is suspended. 

There is more to say here (concurrency and "par", applications to
memory management, category theory) but that will have to happen
some other time.

## Putting it all together

Types can be defined by either introduction or elimination rules, and
the straightforward way to interpret this is to think of negative
types as suspending evaluation ("lazy", unevaluated, "objects") and
positive types as being fully evaluated ("structured data").

Having both of these in a single calculus, that moreover corresponds to
polarized natural deduction, is simply amazing. Surely, being able to
encode various formal calculi that are either call-by-name or call-by-value
is interesting. From a more practical perspective, it is now easy to
see that when one wants to formalize "object-oriented style," which will
decidedly involve something like records on unevaluated functions, this
will involve negative types.

To give a vauge, but hopefully illuminating idea: consider how a "vtable" 
is quite literally a record of function pointers, "waiting" for
program execution to select one among them before proceeding with
computation. And how representing an object involves carrying around a
vtable.

All this makes me think that when formalizing a programming language, it seems
very attractive to translate the calculus to CBPV (or something like CBPV).
Of course, this supposes that formalization is taking place - it looks
like I will finally have some motivation to learn a proof assistant.

I hope you found this little series useful in developing intuition for
linear logic as well as the role of "negative types."
