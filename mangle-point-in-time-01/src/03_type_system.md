# Type system

The type system is a work-in-progress.

I would have liked to present one, alas there are only fragments for now.

## What is a type system good for?

"Well-typed programs cannot go wrong" (Milner)

A type system serves two purposes:
- prevents a class of programmer mistakes
- makes parts of the semantic structure explicit

The first point is what is taught to students. The second point is discourse among researchers, with a heavy bias towards formalizing mathematics.

## The necessary jargon

Mathematics is not the only domain that has semantic structures worthy of making explicit.
But mathematics provides us with the ways of talking about these objects.

Concretely, we have a type expression \\( T \\) that stand in for an object \\( [\\![T]\\!] \\).
Type expressions are formal objects or "linguistic signs". They are enumerable.

If an expression \\( e \\) "can be assigned the type \\( T \\)" then
  * we can talk about a "meaning" \\( [\\![e]\\!] \\)
  * (soundness) \\( [\\![e]\\!] \\) is conforming to \\( [\\![T]\\!] \\) 

Some remarks:
  * Using the same symbols \\( [\\![\ ]\\!] \\) for taking expressions and type expressions to the "meaning" is a case of "overloading." Mathematicians love overloading as a means to conversation focused on what is essential. This is a form of abstraction.
  * This is Church-style. We do not bother to give meanings to expressions that cannot be assigned a type. The alternative is Curry-style, define a "meaning" for all expressions, independent of whether they can assigned a type or not.
  
A simple way (not the only way) to make all this work is to say that:
  * \\( [\\![T]\\!] \\) is a *set*.
  * "conforming" is membership: \\( [\\![e]\\!] \in [\\![T]\\!] \\)

Simplicity is good, but we should not forget where we came from: a desire to prevent programmer mistakes and making part of the semantic structure explicit.

## Elements of Mangle type system 

Expressions
  * base constants \\( c \\) like names, numbers, strings, ...
  * structured constants 
    * lists \\( [e_1, \ldots, e_n] \\),
    * pairs \\( \mathtt{fn:pair}(e_1, e_2) \\) 
    * maps \\( [ e_1 : v_1, \ldots, e_n : v_n ] \\) 
    * structs \\( \\{ l_1 : v_1, \ldots, l_n : v_n \\} \\)

Type expressions (meta variables \\( S, T \\))
  * \\( \mathtt{/any} \\)
  * base type expressions \\( \mathtt{/name}, \mathtt{/number}, \mathtt{/float64}, \mathtt{/bool} \\)
  * stuctured types
    * list type \\( \mathtt{fn:List}(T) \\)
    * pair type \\( \mathtt{fn:Pair}(S, T) \\),
    * map type  \\( \mathtt{fn:Map}(S, T), \\),
    * struct type \\( \mathtt{fn:Struct}(k_1,T_1,...,k_n,T_n) \\)

For example \\( \mathtt{/bool} \\) is a type expression, with \\( [\\![\mathtt{/bool}]\\!] = \\{\mathtt{/true}, \mathtt{/false}\\} \\) .

## Finite models and finite theories

The history of programming *languages* starts with formal mathematical logic, types and metamathematics (Frege, Russell, Hilbert.) This is when we started
subjecting the symbols used in mathematics to rigid, explicit, precise rules of formation and vocabulary. It is the beginning of metalanguage and object language.

When we talk about the linguistic domain of mathematics, restricting to anything finite means we will lose the mathematicians' interest.

Finite domains are practical value and therefore a simple starting point when programming system that serve practical purposes.

It is therefore good and useful to start with a domain of discourse assuming that deals with a finite amount of objects.

We can now define *predicates* which express how objects in the domain of discource are *related*.

In the language of set theory, the meaning of predicates is a *relation* (subset of cartesian product). A predicate can either be defined by *enumerating* (extensional predicate) or by *describing* rules (intensional predicate) and so on.  

More generally, a *theory* is a set of propositions that are true. A finite model comes with a finite theory.

## Declarations and Types

We can describe predicates further by being more specific on what types the arguments have.

```
Decl foo_pattern_first_A_then_B(Host, T1, T2) 
  descr [
    doc("A detection rule expressing the foo pattern (a sequence of A and B)" ),
    arg(Host,   "name constant /host/fqdn prefix, with fully-qualified domain name"),
    arg(T1,     "a timestamp, seconds since epoch UTC"),
    arg(Source, "the external source that ingests events")
  ]
  bound [ /host/fqdn, /number, /number ].

# Let's query the data
? foo_pattern_first_A_then_B(/host/fqdn/burakemir.ch, X, Y)
```

## Modularity and extensibility

From a programmer's point of view, it is desirable to split large programs into *modules*,

Mangle offers modules through the *package* mechanism:
- one can refer to *public* predicates in a package.
- (in the future) type declarations could be used to type-check module separately.

Currently, Mangle is interpreted and semantic analysis operates on a whole program.

Something akin to the "Rust orphan rule" which restricts trait implementations:
- One cannot add facts through unit clauses for predicates that live in separate modules
- An exception: for extensional predicates, it is allowed (path dependence)
  - Esp. for *testing*, we'd like to set up facts for predicates in other modules...

<!-- However, int

For the result of applying a predicate, we use \\( \Omega \\).

<br>The meaning \\( [\\![S]\\!] \\) of a type expression is a set.

\\[ \frac{\vec{X}:\vec{S} \in \Gamma \quad \vec{S} <: \vec{T} \quad q : \mathbf{Rel}(\vec{T})}{\Gamma \vdash q(\vec{X}): \Omega} \\]

-->