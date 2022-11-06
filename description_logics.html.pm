#lang pollen
◊(define-meta page-title "Pollen for the homepage")
◊(define-meta page-kind article)

◊h1{Description Logics}

◊p{
Description logics (DLs) are a family of formal languages used for
knowledge representation. Knowledge representation (a subfield of artificial intelligence)
deals with capturing a domain of interest in machine-readable form,
for purposes of automated reasoning.
}

◊;◊p{
◊;Formal logic is one of the origins of programming and appears in
◊;multiple ways in academic discussions of programming languages. For
◊;instance, the specification of programming language involves defining
◊;syntax and semantics. These can be seen as defining an intended ◊em{model}
◊;and a program written in such a language corresponds to a ◊em{theory}.
◊;}

◊;◊p{
◊;DLs as a logic-based approach to knowledge representation are different:
◊;here, we set out to describe concepts of a domain and how they relate to
◊;each other using formal statements. The emphasis is on formalisms where
◊;common reasoning tasks are ◊em{decidable}.
◊;}

◊h2{DL Knowledge Base}

◊p{In a given DL setup, a ◊em{knowledge base} (KB) is split into a ◊em{terminological}
part (TBox) and an ◊em{assertional} part (ABox).
}

◊ul{
   ◊li{the TBox represents static
knowledge about the conceptual structure of the domain, similar to
a database schema,} 
   ◊li{the ABox represents information about concrete
real-world entities, like the rows in a database instance.}
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

◊h1{Ontology Engineering}

◊p{
Suppose we want to capture a domain through a concept definitions;
why would we go through the effort of formalizing logical? In order
to see the advantages of formalism, we have to look at this scenario
more closely.}

◊ul{
◊li{
It may be the case that people only shared understanding at an abstract level,
but do not agree on details that matter. The clients interested in the
shared knowledge base may not even be in a position to produce necessary detail, or 
there stakeholders differ on details in ways that matter to them. )
}
◊li{or there is an established set of concepts, which stems from a time where the
environment was different. The environment, and therefore the relevant concepts in
the domain and how they interact, can change due to scale, additional requirements or
other external factors, e.g. ehe applications of two different databases need to be reconciled, in
a way that lets the applications still work.
}
}

◊p{The bottom line is that one needs to capture an actual, up-to-date terminology. One
well-known example of DL is the Web Ontology Language (OWL) which is
used in the context of semantic web.}

◊h2{Some Limitations: Triples all the way down}

◊p{
A role is always a binary relation, which makes a role assertion into a triple (e.g. subject-predicate-object, or entity-attribute-value). This is
great because it enables uniform representation in triple stores, however
there are real-life concepts where the limitation to binary relations
is artifical. While there are ways to encode using artifical concepts (RDF blank nodes) Entity-relationship model
}

◊h2{Further reading}
◊p{
◊a[#:href "https://en.wikipedia.org/wiki/Description_logic"]{Description logics on wikipedia}
}
◊p{Baader, F., Horrocks, I., Lutz, C., Sattler, U.. An Introduction to Description Logic. 2017 Cambridge University Press.}

◊p{Baader, F., Calvanese, D., McGuinness, D., Nardi, D., & Patel-Schneider, P. (Eds.). (2007). The Description Logic Handbook: Theory, Implementation and Applications (2nd ed.). Cambridge: Cambridge University Press. doi:10.1017/CBO9780511711787}