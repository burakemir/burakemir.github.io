+++
title = "Programming Language Semantics and Memory Safety"
date = 2026-08-21
[taxonomies]
categories = ["blog"]
tags = ["memory safety", "semantics", "rust", "c", "c++"]
[extra]
math = true
+++

***

Have you ever wondered what a programming language *actually is*? 

People often say that a programming language is just a tool we use to tell computers what to do. I really don't like this metaphor.
Tell me then, how does this tool work? 

At university, we may learn that a language is defined by its **syntax** and its **semantics**,
along with ways to make these definitions with mathematical precision. For syntax, there is grammar, but for semantics?

### Why care?

Memory safety, what else! I have been working on memory safety for a few years now. I helped
get Rust adopted at Google as a lead of the Rust team, I joined memory safety standard discussions on behalf of Google. I met professionals with all sorts of view on the topic. 
I even contributed to design discussions of the Carbon programming language and a bit to its implementation, though unsure whether that matters.
I am between jobs at the moment, so for once don't need to worry about the not-my-employer's-opinion disclaimer.

To me, memory safety is a programming language topic. I love PL! It is a wild field of research with conventions and jargon that most people don't have access to. Hopefully this
article fixes that a little bit.

Memory safety would actually be an opportunity to put PL research into the spotlight! Alas, there are broad, political reasons that make fact-based discussions hard.
* When grown-ups talk about safety, they really mean cybersecurity. Preventing attacks is the main concern and driving force, conventions, testing, mitigations just won't cut it.
* security is risk-based and thus a frequent exercise in making trade-offs and economic arguments. 
* the world is drowning in legacy code 

Investing into security involves uncertainty, even if it is clear that something needs to change.
We don't need to fully replace C and C++ in order to significantly improve security, but it will cost - time and money.
When fighting over limited resources, you will not only find honest people arguing over hard decisions and also people who push a more selfish agenda.

I think academic PL people are a lot like mathematicians in that they practical application of their work, hoping someone with money and influence will discover their work and put it to good use.

So I will do the same! What follows is an invitation to get back to the _science_ of programming. If you want your compiler and libraries
to work correctly and be secure, _someone_ has to argue from principles. 

### Diving into formal semantics

When you write `x = y + 1`, how do we formally define what that means? It turns out, there are three main ways to look at it: **Operational**, **Denotational**, and **Axiomatic** semantics. 

These sound like intimidating academic terms, but as a working developer, you already intuitively understand the concepts. You just know them by different names: *interpreters*, *compilers*, and *assertions*. All these views on languages are simultaneously useful. 

To break this down, let’s invent a tiny toy language. It has arithmetic, immutable variables (`let`), and mutable variables (`var`). 

Here is a snippet of our toy language:
```text
var x = 0;
let y = 5 in
    x = y + 1
```
*`x` is a mutable variable initialized to 0. `y` is an immutable variable bound to 5. Finally, we update `x`.*

Let’s look at this snippet through the three lenses of formal semantics.

---

### 1. Operational Semantics: The "Interpreter" View

**The core question:** *How do we execute this code step-by-step?*

Operational semantics defines a program's meaning by describing how it executes on an abstract machine. It is less concerned with "what it mathematically is" and more concerned with "how it runs." 

If you have ever written an interpreter, you have provided an operational semantics. It may not the best choice for typesetting and and publishing it in an article or book, but a program
can certainly count as providing rules defined with mathematical precision. The researchers use a set of logical rules (often called Structural Operational Semantics) that involve rewriting 
a bunch of formal symbol strings.  But practically, the essence is this:

We keep track of a **State** (a mapping of mutable variables to their values) and an **Environment** (a mapping of immutable `let` bindings to their values).

1. **Initial State:** `{ x: 0 }`, **Env:** `{}`
2. Evaluate `let y = 5`. We add `y` to the environment.
   **State:** `{ x: 0 }`, **Env:** `{ y: 5 }`
3. Evaluate `x = y + 1`. We look up `y` in the Env (5), add 1, and update `x` in the State.
   **State:** `{ x: 6 }`, **Env:** `{ y: 5 }`

**Why developers care:** Operational semantics is the most common way to define language specifications. We just expect that it is clear and well-defined what happens when a line of code runs. When the ECMAScript specification describes how JavaScript should execute, it uses a form of operational semantics. It answers the question: *"What happens when this line of code runs?"*

---

### 2. Denotational Semantics: The "Compiler" View

**The core question:** *Tell me (with mathematical precision) what object does this code represent?*

Denotational semantics takes a different approach. Instead of defining *how* a program runs, it maps the program to what a program is (a "denotation"). In formal semantics, 
this is a mathematical concept and a semantics is essentially translation - a mathematical compiler.

What is crucial is not mathematics but that the target of translation is something
we already understand and need not define further. Also, we need to be able to tell whether two translated objects are "the same".

Back to our little language. Instead of stepping through the code, we translate each line into a mathematical function. 

*   `var x = 0` translates to a function that takes an input state and returns a new state where `x` is 0.
*   `let y = 5` translates to a function that takes an environment and returns a new environment where `y` is 5.
*   `x = y + 1` translates to a function that takes a State and an Environment, looks up `y`, adds 1, and updates `x`.

In denotational semantics, the entire program is simply a composition of these mathematical functions. 

If $S$ is our State and $E$ is our Environment, our program becomes a single mathematical function $P$:
$$P(S, E) = S' \text{ where } S'(x) = E(y) + 1$$

Notice that we never talked about "running" the code step-by-step. We just said: "This program is a function that maps an input state to an output state."
It is the concepts of mathematical function and function compositions where the magic happens.

The compiler analogy is deeper than it seems: if I hand the Rust grammar and a Rust compiler to
someone who only knows the machine code and target platform, they could learn from that what any Rust program means.
Hopefully the compiler is correct, though. So just a compiler is hardly enough. We really need some other definition of semantics
in order to tell whether a compiler is correct.

**Why developers care:** Denotational semantics makes it easy to prove things about programs mathematically. If you want to prove that two different code snippets do the exact same thing, denotational semantics allows you to just prove that their translations (say, into mathematical functions) are identical. It also forms the basis for pure functional languages like Haskell, where we would like see programs as mathematical functions.

---

### 3. Axiomatic Semantics: The "Assertions" View

**The core question:** *What is true before and after this code runs?*

Axiomatic semantics completely ignores *how* a program runs or what mathematical function it represents. Instead, it defines a program's meaning by its effect on logical propositions. 

If you have ever written a unit test or used an `assert` statement, you are already doing axiomatic semantics.

We use something called **Hoare Triples**, written as `{P} C {Q}`.
This means: *If precondition P is true before running code C, then postcondition Q will be true after it runs.*

Let's look at our snippet:
```text
var x = 0;
let y = 5 in
    x = y + 1
```

What can we say about this code using axioms?
1. We can assert a precondition: `{ True }` (We don't need anything to be true beforehand).
2. We run the code.
3. We can assert a postcondition: `{ x == 6 }`

Therefore, our Hoare triple is:
`{ True } var x = 0; let y = 5 in x = y+1 { x == 6 }`

But how do we *know* the postcondition is true without running it? We use logical axioms. For instance, the axiom for assignment (`x = E`) says that if you want `{ x == 6 }` to be true *after* the assignment, then `E == 6` must be true *before* the assignment (with `x` substituted by `E`).

**Why developers care:** Axiomatic semantics is the foundation of formal verification and program proving. When ESA writes software for spaceships, they don't just test it; they use axiomatic semantics to mathematically prove that certain postconditions (like "the thrusters won't fire when the hatch is open") are mathematically guaranteed by the code. Tools like modern static analyzers and proof assistants (like Coq or Dafny) rely heavily on this view.

---

### Interlude: Which lens should you use?

You don't have to choose just one! Each semantic model gives us a different tool for a different job:

*   **Operational Semantics:** "How does this execute?" Think *Interpreters*. Great for language designers writing a reference implementation.
*   **Denotational Semantics:** "What does this mean mathematically?" Think *Compilers to Math*. Great for proving equivalencies between different pieces of code.
*   **Axiomatic Semantics:** "What can we prove is true?" Think *Assertions*. Great for verifying safety and correctness.

Formal semantics doesn't have to be a terrifying realm of Greek letters. By shifting your perspective from "running code" to "interpreting, translating, and proving," you gain a deeper understanding of the tools you use every day.

---

### The Dark Abyss of Undefined Behavior and Memory Safety

I want to take this a step further into the real world and connect this to compilers and memory safety.

If you write C or C++, you are intimately familiar with the dreaded phrase **Undefined Behavior** (UB). 

Memory safety issues—like buffer overflows, use-after-free, or null pointer dereferences—are all categorized as UB. But what does UB actually mean in the context of formal semantics? And why did a professor once tell me that the C specification can be understood as axiomatic semantics, even though UB feels like an operational gap?

It turns out, operational and axiomatic semantics view UB from two different sides of the same coin. 

#### The Operational View: The Missing Rule

From an **operational semantics** perspective, a programming language is defined by a set of transition rules (e.g., "If state is X, move to state Y"). 

Undefined behavior is exactly what it sounds like: **a gap in the specification.** It is a bland statement "we are neither willing not able to tell what happens next".
A specification gap is very different from leaving something up to the implementation ("implementation-defined").

Suppose our toy language has pointer arithmetic, and we write a rule for accessing an array. The rule says: *“If index `i` is within the bounds of the array, return the value.”* 

But what if `i` is out of bounds? We simply didn't write a rule for that. In operational semantics, if a program reaches a state where no rule applies, the abstract machine is "stuck." The specification says nothing about what happens next. The program might crash, it might read garbage data, or it might format your hard drive. Operationally, it is a black hole.

#### The Axiomatic View: The Void Consumes Logic

So, where does **axiomatic semantics** come into play? The professor was likely looking at the C standard through the lens of Hoare Logic (assertions).

In axiomatic semantics, we define rules for how statements affect preconditions and postconditions. For a normal statement, we might say:
`{ x == 5 } x = x + 1 { x == 6 }`

But how do we axiomatize a statement that has undefined behavior, like dereferencing a null pointer? 

In axiomatic semantics, UB is handled by a terrifying but mathematically elegant principle: **If the precondition for safe execution is not met, the program can do literally anything.**

Let’s say the C standard has an axiom: 
*“If you dereference pointer `p`, `p` must not be null.”*

If we write code that *might* dereference a null pointer, the precondition for that code block is violated. In formal logic, if you start from a false premise, you can prove anything to be true (this is called the Principle of Explosion). 

Therefore, the Hoare triple for UB becomes:
`{ False } C { Anything }`

*(If the precondition is false, any postcondition is true).*

#### Resolving the Conflict: The Compiler's Loophole

So, how do we resolve this? Is UB a missing operational rule, or an axiomatic logical explosion? 

**It is both, and that is why compilers behave the way they do.**

Modern C/C++ compilers (like GCC and Clang) don't just interpret your code; they rely on the **axiomatic semantics** of the C standard to optimize it. 

Because the standard says out-of-bounds access is UB, the compiler assumes—axiomatically—that you will never do it. 

Here is a classic example:
```c
int table[10];
for (int i = 0; i <= 10; i++) {
    table[i] = 0;
}
```
Operationally, when `i` reaches 10, there is no rule for what happens. But the compiler doesn't just stop. It looks at the axioms. 

The compiler could reason like this:
1. Accessing `table[10]` is Undefined Behavior.
2. The programmer would never write code with Undefined Behavior (because it breaks the preconditions of the language).
3. Therefore, `i` can never reach 10.
4. Therefore, the condition `i <= 10` is always true.
5. Therefore, this is an infinite loop!

The compiler is free to optimize this into a hardcoded infinite loop, completely removing the bounds check. The axiomatic gap allows the compiler to assume the impossible.

Note that this is not the only behavior you may get. On my Mac, `clang` has "-fstack-protector" on by default and this program will abort before returning.
If I switch that off, it will simply run and presumably write to a place where it is not supposed to write. Everything is possible!

We may think "would it not be nicer if the compiler told us that this can be UB and signaled an error?" Have the
compiler authors "weaponized UB"? Well, in the early days of C there were a lot of platforms and implementation, and agreeing
on behavior may have been impossible. In this example,
it is easy for us to see, but analyzing and diagnosing code without running it (static checking) is hard work.
Both for specifying and for implementing.
The authors of the C and C++ specs took the easy way out and so the spec actually permits them to do "anything".

The grounds have also shifted. Concurrency makes everything a lot harder. Since the mid-2000s, CPU architectures feature multiple cores and concurrency.
Multithreading is much older than that, but it used to be implemented by time-slicing. With multicore
CPUs, threads would actually execute at the same time. Since then, understanding a natively executed program requires the
spec to talk about multiple threads executing in parallel. The C and C++ memory models (which are different) were specified _decades_ after the language
specs.

#### The Lesson for Memory Safety

This is why memory safety is such a profound issue. It’s not just that a buggy line of code might crash. If the specification says something results
in a crash (program is aborted), this is actually great: we know exactly what happens, we can diagnose, debug, test, fix.

When a language allows for undefined behavior, it creates a logical void. Once the program enters that void, the axioms the compiler used to optimize the rest of your program no longer hold. A single memory safety bug invalidates the guarantees of every other line of code around it. UB means you *broke the language*.

The grounds have shifted multipe times since C and C++ were invented. Fortunately, researchers have found ways of proving programs safe, primarily using more advanced type systems.

This is why modern languages like Rust are a step forward. The Rust community uses the word "safe" to there is evidence (proof) that a program does not have UB. This
is a lot more than patching the operational gaps of C. Its borrow checker acts as a proof assistant, ensuring that we can derive from the axioms and rules of memory safety
that the program is allowed to compile. Reading from places that are initialized. It also explains what unsafe Rust really is: we are permitted to color outside the lines,
as long as we can argue in safety comments why the axioms and rules of memory safety will still work. 

By understanding formal semantics, you can see exactly why a language is safe or unsafe (in the sense of guaranteeing absence of UB). All we want is to be able to reason with mathematical precision.
Things like deallocation and pointer arithmetic make it harder or impossible to provide guarantees, but that is a topic for a different day.

