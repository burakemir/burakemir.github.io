# Porting Mangle to Rust

I have started work on porting Mangle to Rust. The reason is the same
one why Mangle was started in go in the first place: when pragmatic
solutions, the environment determines what languages is the best fit.

Mangle was started in an environment that required go. Now I want to
access Mangle functionality in places that use C++ and Rust. And
I want to find out whether a particular approach to manipulating
symbolic data can be made to work well in Rust (more on this below).

## But ... why?

For pure single-machine usage, it is very feasible to just do Rust go interop using IPC or grpc.
There is a section "Server" that talks about this, with demo code.

For a project like this, one can come with a few reasonable questions:
- why port instead of e.g. working on features or documentation
- after the port is done, is it not hard to maintain two versions
- why have another datalog implementation when there are so many good ones?

These are all good questions, and I pondered them before embarking.
The tentative answers and mitigations:
- while the surface language is far from perfect, the few additions
that are necessary for syntax seem doable in two implementations.
- the type-checker is more work and unfinished, but that could be left for later.
- Mangle is supposed to be not just "an implementation" but a specification;
that is only convincing when there are at least two implementations.

## Other Rust datalog implementations

There are indeed a lot of datalog implementations in Rust. Here are a few:
- [Datafrog](https://github.com/rust-lang/datafrog) - very limited and hard to read
- [Ascent](https://s-arash.github.io/ascent/) - embed any type as relation, BYODS
- [Crepe](https://github.com/ekzhang/crepe) - seminaive and stratified negation, Eric K. Zhang's [thesis](https://www.ekzhang.com/assets/pdf/Senior_Thesis.pdf) as accompanying reading material
- [DDlog](https://github.com/vmware/differential-datalog) - I don't know much about this one
- [asdi](https://github.com/johnstonskj/rust-asdi) - Another Simplistic Datalog Implementation

These are all datalog implementations, and, like Mangle, some add extensions to Datalog.
If we look beyond Rust, there are of course many more implementations.


As discussed elsewhere (pardon the approximate self-quoting - this is just my opinion): 
> I think it is helpful to see datalog as a formal, conceptual kernel (or "toy programming language" in the famous Alice Book "Foundations of Databases"). When we look at the functional programming languages, we do not usually see them as a dozen of incompatible implementations of lambda calculus.

The compilation technique of Ascent and Crepe is certainly something that would make sense for Mangle.

I should study these Rust datalog implementations more, but here is clear difference:
already today, Mangle has support for deferred computation that adds
back some of the PROLOG top-down evaluation possibilities, without
adding the problems like order-sensitivity that come from
PROLOGs non-declarative execution model. Tomorrow, I may want
to add equality saturation or convenient syntax to encode
algebraic datatypes - this could only happen in Mangle.

## Compilation left for later

One issue with Mangle is that datalog evaluation is essentially interpreted. This may
be helpful for evaluating queries at runtime, and when data fits in memory then the
lightweight computation does not really matter. However, there are scenarios where
it is not possible to use Mangle now:
- working with large data sources that does not fit in-memory.
- when there is more computation to do than the immediate-consequence operator

For now, the Rust port of Mangle will stick as close as possible to the
golang implementation.

The challenge is to avoid the creep of features that make compilation impossible.
This might already have happened, but since Mangle is still far from 1.0, there
is still room to maneuver.

Finally, if it turns out that change to Mangle-golang are not possible, then
it will still be possible to evolve Mangle-rust to the compilation model
while keeping golang interpreter intact.

