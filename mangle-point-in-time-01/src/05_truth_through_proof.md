# Truth through proof

(A subtle reference to P. Andrews logic textbook)

The words "proof" and "evidence" carry importance beyond the realm of formalized mathematics.

We want to make reasoning explicit - but:

- not all reasoning is certain, deductive.
- data may be unavailable, not trustworthy
- humans matter (we have a responsibility toward each other)

Having explicit rules means that definitions (vocabulary) and invariants.
This means:

- it is easier to know which data we *do* have
- it is easier to automate certain, deductive reasoning

There will be always be judgment calls, and the need for human control and responsibility.

The more successful applications of AI will there not *replace* humans, but *augment* human work and decision making.

## Augmenting the LLM

I believe (but cannot prove) that it will be *much* easier to enhance prompts with precise, accurate facts obtained from logic programming rather than doing detours through training, fine-tuning.

Rather than have AI *solve* Codd's "parts explosion" problem, it seems much easier to compute all the parts from our catalog and feed the result to the model and be done.

Mangle and datalog-based languages let us write that logic concisely and in a way that can be tested.

It will be interesting to see how logical inference and ML model inference can be alternated.

```go
func TestTransformPartsExplosion(t *testing.T) {
	store := factstore.NewSimpleInMemoryStore()
	program := []ast.Clause{
		// The 'component(Subpart, Part, Quantity)' relation expresses that
		//    <Quantity> units of <SubPart> go directly into one unit of <Part>.
		clause(`component(1, 5, 9).`),
		clause(`component(2, 5, 7).`),
		clause(`component(3, 5, 2).`),
		clause(`component(2, 6, 12).`),
		clause(`component(3, 6, 3).`),
		clause(`component(4, 7, 1).`),
		clause(`component(6, 7, 1).`),
		// The `transitive(DescPart, Part, Quantity, Path)` relation
		// expresses that <Quantity> units of <DescPart> go overall into one
		// unit of <Part> along a dependency path <Path>
		clause(`transitive(DescPart, Part, Quantity, []) :- component(DescPart, Part, Quantity).`),
		clause(`transitive(DescPart, Part, Quantity, Path) :-
		  component(SubPart, Part, DirectQuantity),
		  transitive(DescPart, SubPart, DescQuantity, SubPath)
      |> let Quantity = fn:mult(DirectQuantity, DescQuantity),
	       let Path = fn:list:cons(SubPart, SubPath).`),
		// The `full(DescPart, Part, Quantity) relation expresses that <Quantity>
		// units of <DescPart> go overall into one unit of <Part>.
		clause(`full(DescPart, Part, Sum) :-
		  transitive(DescPart, Part, Quantity, Path)
      |> do fn:group_by(DescPart, Part), let Sum = fn:sum(Quantity).`),
	}
	if err := analyzeAndEvalProgram(t, program, store); err != nil {
		t.Errorf("Program evaluation failed %v program %v", err, program)
		return
	}
	transitiveAtom, err := functional.EvalAtom(atom("transitive(2,7,12,[6])"), ast.ConstSubstList{})
	if err != nil {
		t.Fatal(err)
	}
	expected := []ast.Atom{
		transitiveAtom,
		atom("full(2,7,12)"),
	}

	for _, fact := range expected {
		if !store.Contains(fact) {
			t.Errorf("expected fact %v in store %v", fact, store)
		}
	}
}
```

Other examples / ideas:
- kythe.io - semantic indexing of source code (a graph).
  - distinguish between definition and use