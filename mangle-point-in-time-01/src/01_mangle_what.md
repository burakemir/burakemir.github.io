# A tour of Mangle

A "hosted" domain-specific language from the extended datalog family. 
- meant to be used as library from within a general-purpose language.
- *not* an "embedded DSL" since it does not elements of the host language

Why? We want Mangle implementations in different host languages (e.g. Rust…).

(Eventually want to generate and run beam-go programs for large scale persisted data.)

## What's up with the name?

A reference to "The Mangle of Practice: Time, Agency, and Science" by Andrew Pickering.

<!--web-only-->
"The practical, goal-oriented and goal-revising dialectic of resistance and accommodation is, as far as I can make out, a general feature of scientific practice. And it is, in the first instance, what I call the mangle of practice, or just the mangle. I find "mangle" a convenient and suggestive shorthand for the dialectic because, for me, it conjures up the image of the unpredictable transformations worked upon whatever gets fed into the old-fashioned device of the same name used to squeeze the water out of the washing. It draws attention to the emergently intertwined delineation and reconfiguration of machinic captures and human intentions, practices, and so on."
<!--web-only-end-->

## Datalog

A "kernel" logic programming language. Example: reachability in a graph 

```
edge(0, 1).
edge(1, 2).
edge(1, 3).

reachable(X, Y) :- edge(X, Y).
reachable(X, Z) :- edge(X, Y), reachable(Y, Z).
```

Datalog can be extended to support negation:
```
not_reachable(X, Y) :- node(X), node(Y), !reachable(X, Y).
```

Restrictions:
- no function symbols
- "datalog safety": all variables in head must appear non-negated in body.
- "stratified negation": only permit negation when a relation can be fully computed before evaluating. Then, negation simply means the fact is not present.

### Name constants

We had to enumerate a lot of things, therefore added *name constants*.

Example: `/foo`

Names can be structured `/foo/bar/baz`. Not quite URIs, but almost: they identify "things", 

```
# A way to give a name to a github_repo https://github.com/aioaneid/uzaygezen

github_repo(/aioaneid/uzaygezen).
github_repo(/apache/calcite).
github_repo(/google/zetasql).
github_repo(/google/mangle).

# percent-encoding "Health & Beauty" 
product_category(/category/Health%20%26%20Beauty).
```

There is a built-in predicate `:match_prefix(/prefix/name, /prefix)`

## Beyond datalog

Datalog is a "kernel" logic programming - but practical querying needs more.

### Mapping (let-transform)

Transform data → "let-transforms", can call functions "in between" evaluation phases

```
foo(X) :- bar(Y) |> let X = fn:my_transformation(Y).
```

- "safety": a variable from head can also be bound in a let-transform
- want to make it easily recognizable what part is relational, what part is functional
- however, it was too tempting to admit function calls earler, so one can write this as follow:

```
foo(X) :- bar(Y), X = fn:my_transformation(Y).
```

### Grouping and aggregations (do-transforms)

```
bar(X, Num) :- bar(Y, Z) |> do fn:group_by(Y), let Num = fn:count(Z).

foo(X, AllZ) :- bar(Y, Z) |> do fn:group_by(Y), let AllZ = fn:collect(Z).
```

- "safety": a variable from head can also be bound in a do-transform
- the `fn:group_by` argument can be empty, a single variable from body, or a tuple or variables from the body
- `AllZ` is a list (structured data).

### Structured data

- one can add lists `[e1,...,eN]`, `fn:list(e1,...,eN)`
- pairs `fn:pair(e1,e2)`,
- structs `{ /field: value }`,
- maps `[ key: value ]` 

- "accessor" functions. 
  - An observation (without proof): datalog program with recursion and *accessor* function symbols will terminate.
  
### What about other functions?

Mangle will *not* have full-fledged syntax for defining functions inline (maybe separately).

Instead, as it is hosted in some other language, there will be a way to *register* external functions, and maybe predicates.

Looking ahead even further, we'd like to:
- directly support functions that are implemented through WASM modules.
- have such functions/predicates do RPCs to other systems (e.g. retrieval, but also inference, embedding...).

This way, Mangle the language stays small and predictable, but the systems hosting Mangle can be extended.