#lang pollen
◊(define-meta page-title "Pollen for the homepage")
◊(define-meta page-kind article)

◊h1{Pollen for the Homepage}

◊h2{Intro}

◊p{
  This is short article on the use of ◊a[#:href "https://racket-lang.org/"]{Racket programming language} and
  ◊a[#:href "https://docs.racket-lang.org/pollen/"]{Pollen} for these pages. I am a programmer and this is
  a setup that works for me. It is a bit peculiar so I explain. 
}

◊p{
  Why all this technology? Publishing anything on the web involves combining text and layout using
  ◊a[#:href "https://en.wikipedia.org/wiki/Markup_language"]{markup language}. Nobody likes to
  write HTML directly. However, absolutely all ways distracting. markup and "templating" languages are
  terrible and distracting in their own special way. What makes Pollen bearable for me is that it is
  "programmable:" I can use expressions in a programming language and they get evaluated.
}

◊h2{Markup, Variables and Functions}

Pollen supports several modes. I am using the markup dialect (◊code{.pm} extension) which offers a
concise way to specify tags. The heading of this section is written like this:

◊pre{
◊"◊h2{Markup, Variables and Functions}"
}

In the end, a conversion procedure called ◊code{->html} turns every page into an HTML file. The ◊code{h2}
is an HTML tag. 

◊p{
That is not all, though. I can bind an identifier to a value and refer to it like a constant or variable symbol:
◊pre{
    ◊"◊(define x 42)"
  The answer to the ultimate question of life, the universe and everything is ◊"◊|x|"
  }
}

We can also bind identifiers to procedures that we can call:

◊(define (emphasis x) ◊@{◊span[#:class "my-emphasis"]{◊|x|}})

◊p{
◊pre{
    ◊"◊(define (my-emphasis x) ◊span[#:class \"my-emphasis\"]{◊|x|}}"
  Markup is code, and I prefer code with ◊"◊my-emphasis{procedure-calls}".
  }
}
will produce ◊code{<span class="my-emphasis">procedure-calls</span>}.
