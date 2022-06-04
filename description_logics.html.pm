#lang pollen
◊(define-meta page-title "Pollen for the homepage")
◊(define-meta page-kind article)

◊h1{Description Logics}

◊p{
Description logics (DLs) are a family of formal languages used for
knowledge representation, a subfield of artificial intelligence that
deals with capturing a domain of interest in machine-readable form,
for purposes of automated reasoning.
}

◊p{
Formal logic is one of the origins of programming and appears in
multiple ways in academic discussions of programming languages. For
instance, the specification of programming language involves defining
syntax and semantics. These can be seen as defining an intended ◊em{model}
and a program written in such a language corresponds to a ◊em{theory}.
}

◊p{
DLs as a logic-based approach to knowledge representation are different:
here, we set out to describe concepts of a domain and how they relate to
each other using formal statements. The emphasis is on formalisms where
common reasoning tasks are ◊em{decidable}.
}

◊p{In a given DL setup, we distinguish between a ◊em{terminological}
part (TBox) and an ◊em{assertional} part (ABox). The TBox an ABox
together are called ae ◊em{knowledge base} (KB). The TBox represents static
knowledge about the conceptual structure of the domain, similar to
a database schema, while the ABox represents information about concrete
real-world entities, like the rows in a database instance.
}

◊h2{An Example}

Suppose we want to define a university domain. The TBox should capture this:
◊ul{
◊li{a teacher is a person who teaches a course}
◊li{a student is a person who attends a course}
◊li{students cannot teach courses}
}

Then the following first-order logic statements capture these definitions:

◊ul{

◊li{ $\forall x. \mathsf{Teacher}(x) \Leftrightarrow
\mathsf{Person}(x) \wedge \exists y( \mathit{teaches(x,y) \wedge
\mathsf{Course}(y)})$ }

◊li{ $\forall x. \mathsf{Student}(x) \Leftrightarrow
\mathsf{Person}(x) \wedge \exists y( \mathit{attends(x,y) \wedge
\mathsf{Course}(y)})$ }

◊li{ $\forall x. \exists y. \mathit{teaches}(x,y) \Rightarrow \neg
\mathsf{Student}(x) $
}

}

◊p{
An ABox may then be a set of assertions that uses the concepts and roles
from the TBox. For example "Salima is a teaching course CS600" becomes
◊ul{
◊li{$\mathsf{Person}(\mathsf{Salima})$}
◊li{$\mathsf{Course}(\mathsf{CS600})$}
◊li{$\mathit{teaches}(\mathsf{Salima}, \mathsf{CS600})$}
}

The DL community uses a different syntax, where these would be written as follows:

◊ul{
◊li{$\mathsf{Teacher} \equiv \mathsf{Person} \cap \exists \mathit{teaches}. \mathsf{Course}$}
◊li{$\mathsf{Student} \equiv \mathsf{Person} \cap \exists \mathit{attends}. \mathsf{Course}$}
◊li{$\exists \mathit{attends}. \top \sqsubseteq \neg \mathsf{Student}$}
◊li{$\mathsf{Salima}:\mathsf{Person}$}
◊li{$\mathsf{CS600}:\mathsf{Course}$}
◊li{$(\mathsf{Salima}, \mathsf{CS600}) : \mathit{teaches}$}
}

}

◊p{
The KB can infer that $\mathsf{Salima}:\mathsf{Teacher}$, and DL can
help establish relationship between concepts, e.g. whether a concept
is more specific than another (subsumption).
}

◊h1{An Application: Ontology Engineering}

◊p{
If we have a fixed, well-known set of concepts, why would we go through
these lengths of capturing things in a research-y formalism? There are
a few scenarios.
}

◊p{
For example, you don't actually have an established set of concepts, but there is no
actual agreement on details (software development everyday situation, most
often in aggravated form where stakeholders have a conceptualization
but cannot produce necessary detail, or different stakeholders have
different details and disagree. )
}

◊p{Or you had an established set of concepts, but the environment changes.
The applications of two different databases need to be reconciled, in
a way that lets the applications still work.
}

◊p{The bottom line is that one needs to capture the actual terminology. One
well-known example of DL is the Web Ontology Language (OWL) which is
used in the context of semantic web.}

◊h2{Some Limitations: Triples all the way down}

◊p{
A role is always a binary relation, which makes a role assertion into a triple (e.g. subject-predicate-object, or entity-attribute-value). This is
great because it enables uniform representation in triple stores, however
there are real-life concepts where the limitation to binary relations
is artifical. While there are ways to encode using artifical concepts (RDF blank nodes) Entity-relationship model

◊h2{Further reading}
◊p{
◊a[#:href "https://en.wikipedia.org/wiki/Description_logic"]{Description logics on wikipedia}
}
◊p{Baader, F., Horrocks, I., Lutz, C., Sattler, U.. An Introduction to Description Logic. 2017 Cambridge University Press.}

◊p{Baader, F., Calvanese, D., McGuinness, D., Nardi, D., & Patel-Schneider, P. (Eds.). (2007). The Description Logic Handbook: Theory, Implementation and Applications (2nd ed.). Cambridge: Cambridge University Press. doi:10.1017/CBO9780511711787}