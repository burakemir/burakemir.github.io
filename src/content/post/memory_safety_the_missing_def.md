+++
title = "Memory Safety - the missing definition"
date = 2025-09-04
[taxonomies]
categories = ["blog"]
tags = ["rust", "carbon", "c++", "safety"]
[extra]
math = true
+++

There is still no standard, precise definition of memory safety. Here is a modest proposal.

<!-- 
Yet, we need one.

A definition that is both broadly applicable and precise is also not easy to come by. 
In the following, I argue for a particular position. Depending on your background, you may find it 
natural, straightforward or even trivial. However, I fully expect there to be competent people who
find themselves in disagreement.

What I propose is simple: I say, let's anchor memory safety in the realm of **language safety**.
This amounts to separating it from **memory safety of execution environments**. 

Coming to agreement on definitions, and framing is a communication challenge on more than one level.
The 21 authors who wrote ["It is time to standardize memory safety"](https://dl.acm.org/doi/10.1145/3708553) paper 
mention "memory-safe and type-safe languages" as one among many things. I appreciate the quest for
vendor-neutral and technology-neutral terminology and "intellectual framework", and I realize that
there are many programming languages out there. Yet, I do not think it is helpful to ignore the
central position programming language design.

--> 

> Fact. A programming language (PL) consists of a **specification** and **implementation**. 

The specification lays out precisely what the set of accepted programs is and how the code should behave 
when the program is executed. An implementation must *conform* to the specification and is what enables
programmers to actually use the PL to translate programs to executable code and execute them. 

> Fact. Programs are executed in an **execution environment**. 

An execution environment is not necessarily part of an implementation, but it can be (interpreter).
CPU, operating system and system resources are all part of the execution environment.

> Fact. A specification can, implicitly or explicitly, leave the possibility of **execution errors**.

> Definition. There are two classes of execution errors:
>
> *   **trapped** errors: these are reliably detected and dealt with by the execution environment
> *   **untrapped** errors: these are not detected, and execution goes on. The specification cannot prescribe what 
behavior take place.

A trapped error may lead to invocation of an error handler or to execution being aborted ("fail-stop"). 
In contrast, untrapped errors include highly problematic situations like undetected out-of-bounds accesses, use-after-free, integer overflows. They can lead to silent data corruption, 
hard-to-debug crashes, and also to security vulnerabilities that can be exploited by malicious actors. 

<!--
A very simple model by security researcher Thomas Dullien is the _intended finite state machine_[^1]. The program code reflects the programmer's intention of how we want a program to behave, which we can think of as a big finite state machine. However, it ultimately gets executed on a real machine (CPU) that may offer many more states. Some of these states may be outside the programmer's intention, but enable attackers to breach security properties while continuing execution of the program.

The difference between intention and actual possible behaviors applies in particular to provisioning and accessing memory. In PL with automatic memory management, the execution environment takes care of interaction with the operating system to obtain or release memory. This eliminates many execution errors that stem from programmer mistakes such as _dangling reference _bugs.

Without automatic memory management, it is the programmer's job to ensure that all memory accesses are valid. When an invalid access happens, we cannot know what state the execution environment will be in and therefore cannot predict what is going to happen. Bug classes include _out-of-bounds access, use-after-free, _often classified as temporal or spatial memory safety_._

Untrapped errors from invalid memory access are particularly harmful when the system does not manage memory. Such an untrapped error gives the attacker pathways to a large state space of actual behaviors. In contrast, untrapped errors in languages with automatic memory management, while problematic, are less likely to cause harm as the additional invalid states are less exploitable.

**Undefined behavior.** To make things complicated, compiler writers "weaponized" the specification: when source
code does not satisfy assumptions, leading to statically detected case of untrapped errors, this is taken as
a license for compiler to generate code with *arbitrary* behavior. While this can be justified logically "from a contradiction, anything follows", it is hard to see this as rational: users of compilers would (and should) rather exclude the possibility of untrapped errors, instead of having a program whose output cannot be predicted.

We now have all ingredients in place to appreciate a ~~standard~~[^2], technical definition of safety. Other definitions are possible, but this captures an important part of language safety.  \

-->

> Definition: Execution Safety
>
> A program is **execution safe** if its execution never leads to untrapped errors.
>
> A language L is **execution safe** if all L-programs are execution-safe.
>
> An execution environment is **execution safe for a language L** if execution of L-programs can never lead to untrapped L-errors.

Execution-safety does **not** guarantee absence of crashes, absence of memory leaks, or possibility to perform modular reasoning on programs. Nevertheless, it is a very strong guarantee and many PLs in widespread use do not have this property. Execution environments can deal with the consequences of untrapped errors, which may limit the harm even if the language used to write these programs may not be execution-safe.

> Definition: Memory Safety
>
> A program is **memory safe** if no memory access ever leads to untrapped errors.
>
> A language L is **memory safe** if all L programs are memory-safe.
>
> An execution environment is **memory safe for a language L** if execution of L-programs can never lead to 
untrapped L-errors due to an operation involving memory access.

**Brief discussion**

Safety is defined as "absence of unacceptable loss." This requires to what unacceptable loss is. Our
definitions above are focused on the mechanics of execution and do not talk about logic errors, 
password-stealing or crashes. So our definition of memory safety is a "technical definition".

Nevertheless, it seems useful: it applies to a range of programming languages, and thus over
a range of possible language designs.

For safety of execution environment with respoect to a language, it is subtle and important that
the definition of error is tied to language spec L. When an implementation translates to a target language 
of CPU instructions, an operation like "dereferencing a dangling pointer" may turn into
"loading memory from an address" which may not be erroneous from the target language point of view.
What makes the operation in the execution environment erroneous is the intent. This intent,
as far as safety guarantees go, has to be grounded in the language specification.
