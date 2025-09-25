+++
title = "From Operations to Effects: A Journey Through M-Sets"
date = 2025-09-25
[taxonomies]
categories = ["blog"]
tags = ["semantics", "effects", "types", "memory safety"]
[extra]
math = true
+++

This continues a meditation on effects. My last post on the various meanings of effects in the discourse on programming languages (PL)
did very little to show how type and effect discipline may be relevant to memmory safety in programming languages.
Moreover, I encountered a statement I found easy to agree to "before we talk about effects, we need to understand their semantics".

This is an interesting challenge in itself. How do we define precisely what a program that performs I/O actually _means_?
When your code says `IO::get`, how should we describe what is really happening? We can formally answer this by modeling
programs as sequences of operations. This journey will take us from a simple log of operations to the powerful idea of M-sets,
and finally draw a bridge to a possible type and effect systems approach.

---

## The I/O Logbook 📜

Let's start with a simple I/O model. Imagine we only have two operations: reading an integer from an input stream and writing one to an output stream. We can define this set of operations, $OpIO$, as:

$$OpIO := \\{ \mathtt{get} \\} ∪ \\{ \mathtt{put}_i \ | \ i \in \mathbb{N} \\}$$

Instead of executing these operations immediately, let's first think of a program as simply generating a **log** or a **sequence** of these operations. We can represent this sequence as $OpSeq$, which is the set of all possible finite sequences of $OpIO$ operations (in the
language of mathematics, this is the free monoid $OpIO^\*$).

Under this model, the meaning of a program statement is defined by how it transforms this sequence. It's a function from $OpSeq$ to $OpSeq$.



*   `let x = get` is a function that appends $ \mathtt{get} $ to the sequence.
*   `put 42` is a function that appends $ \mathtt{put}_{42} $ to the sequence.

A program that reads an integer and then prints 42 simply produce the sequence $[\mathtt{get}, \mathtt{put}_{42}]$. OK,
that is maybe not breath-taking, but it is a start. This describes the "runtime effects" of a program (that word again), but 
how can we see this as a declarative meaning of our program?

---


### Enter the M-Set: The Interpreter 🎭

So, we have a sequence of operations. Now what? This is where **M-sets** come in.

An M-set (specifically an $OpSeq$-set in our case) is a mathematical structure that gives **meaning** to our sequence. You can think of it as a configurable **interpreter** for our log. The formal definition involves a *right action*, which specifies what will happen for every possible operation (get, put 42, etc.).

The beauty is that we can now assert that we **parameterized** our program's meaning (the sequence) by an M-set. We can plug in
different M-sets to change the program's behavior without changing the program itself:

*   **Console M-set:** A handler that interprets `get` by reading from the keyboard and `put i` by printing to the console.
*   **File M-set:** A handler that interprets the operations by reading from and writing to a file.
*   **Testing M-set:** A handler that interprets `get` by returning a fixed value (e.g., 0) and `put i` by adding the integer to a test buffer.

The M-set is the semantic domain that brings our abstract sequence to life.


---



### Beyond I/O: The Case of Memory 🧠

This powerful pattern isn't limited to I/O. We can apply the exact same idea to memory management. Let's define a new set of memory operations:

$$ OpMem := \\{ \mathtt{alloc} \\} ∪ \\{ \mathtt{free\ n}\ |\ n \in \mathbb{N} \\} $$

Here, $\mathtt{alloc}$ represents allocating a new memory location, and $\mathtt{free}\ n$ represents deallocating location $n$.
Just like before, a program's interaction with memory can be modeled as a sequence $MemSeq = OpMem^\*$. The M-set for this system
would be a model of a heap that defines the semantics of allocating and freeing memory.



---



### The Leap to Type and Effect Systems ✨

In many cases, tracking the _exact_ sequence of operations is overkill. We often don't need to know the entire history; we just want a **summary** of what a function might do. This is the leap from concrete sequences to abstract **effects**.

The operations we've been discussing — get, put, alloc, free — can be called (runtime) **effects**. A **type and effect system** is a
static analysis tool, built into a compiler, that tracks the set of effects a piece of code might trigger.

Instead of a concrete sequence like ["alloc", "free 0"], the effect system provides an **approximation**. It tells us that a function has the potential to perform the effects {alloc, free}. These effects become part of the function's type, giving developers a clear contract about what the function can do.

Furthermore, effects can be parameterized. A function type might look like this:

```
fn update(x: &mut T) -> () effect { free(x[*]) }
```

This signature tells us that the update function _may_ free the memory associated with its parameter x. This brings us to a crucial point: effects are an **approximation**. The `free(x[*])` effect means the function _may_ release memory associated with elements `x[i]`, not
that it _will_ on every execution path. This conservative approach is essential for guaranteeing safety.

And so, we've traveled from a concrete sequence of operations, to a semantic interpreter (the M-set), all the way to an abstract
summary of behavior used in modern type and effect systems to help us write safer, more predictable code. Lots of open
questions here how information expressed in this language of effects (the annotations on the types) could be used for
checking - we cannot talk about runtime values, only refer to them indirectly through expressions that talk about
some set of locations. Unrestricted aliasing may make it impossible to decide whether two expressions refer to an overlapping set
of memory locations. It does seem like a step towards something interesting.

We started with a modest goal: have an answer to the question on the semantics of effects. It looks like we got there:
effects (effect annotations) are may-approximations of runtime effects.

