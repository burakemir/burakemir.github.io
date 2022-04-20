#lang pollen
◊(define-meta page-title "Pollen for the homepage")
◊(define-meta page-kind article)

◊h1{Pollen for the Homepage}

◊h2{Intro}

◊p{
  This is short article on the use of ◊a[#:href "https://racket-lang.org/"]{Racket programming language} and
  ◊a[#:href "https://docs.racket-lang.org/pollen/"]{Pollen} for these pages. I am a programmer and this is
  a setup that works for me. 
}

◊p{You can check out the
◊a[#:href "https://github.com/burakemir/burakemir.github.io/blob/source/pollen.html.pm"]{source}
for this article. It may seem like a peculiar choice so here are a few words of explanation.
}

◊h2{Markup, Variables and Functions}

◊p{
  Publishing anything on the web involves combining text and layout using
  ◊a[#:href "https://en.wikipedia.org/wiki/Markup_language"]{markup language}. Nobody likes to
  write HTML directly. However, as a programmer, absolutely all pre-fabricated ways of producing markup
  feel roundabout and distracting.
}

◊p{What makes Pollen bearable are two things: ◊ul{
◊li{it is "programmable:" one can use programming constructs to control the process.}
◊li{it supports authoring well enough so I am not tempted to roll my own}
}}

Pollen supports several modes. I am using the markup dialect (◊code{.pm} extension) which offers a
concise way to specify tags. The heading of this section is written like this:

◊pre{
◊"◊h2{Markup, Variables and Functions}"
}

In the end, a conversion procedure called ◊code{->html} turns everything into proper HTML. 

◊p{
That is not all, though. I can bind an identifier to a value and refer to it like a constant or variable symbol:
◊pre{
    ◊"◊(define x 42)"
  The answer to the ultimate question of life,
  the universe and everything is ◊"◊|x|"
  }
}

I can also bind identifiers to procedures:

◊p{
◊pre{
    ◊"◊(define (my-emphasis x)
      ◊span[#:class \"my-emphasis\"]{◊|x|}}"
  Markup is code, and I prefer code
    with ◊"◊my-emphasis{procedure-calls}".
  }
}
will produce ◊code{<span class="my-emphasis">procedure-calls</span>}.

◊p{This alone is already a vast improvement over HTML syntax and authoring via copy-and-paste.}

◊h2{Build and Push}

◊p{Currently, I am using good old GNU Make for generating everything, before pushing manually.}

◊p{When authoring, I use ◊code{raco pollen start} which renders each changed file automatically,
and do a manual reload in the browser.}

◊p{Rendering a file individually is done with ◊code{raco pollen render <file>.html.pm}}

◊h2{Inline math with MathJax3}

◊p{Typesetting math like $\pi \nabla \longrightarrow \lambda x. \Omega$ is not handled by Pollen, but by MathJax3.}

◊p{With the bussproofs package, we can do proof trees:

$$
\begin{prooftree}
\AxiomC{$P$}
\AxiomC{$P\to Q$}
\RightLabel{$\to_E$}
\BinaryInfC{$Q$}
\end{prooftree}
$$}