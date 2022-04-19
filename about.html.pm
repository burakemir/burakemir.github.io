#lang pollen
◊(require txexpr)
◊(require pollen/decode)
◊(require "menu.pm")

◊(define-meta page-title "Burak Emir's homepage : About")
◊(define-meta page-kind homepage)

◊(menu "About")

◊h1{About}

◊p{I use the ◊a[#:href "https://racket-lang.org"]{Racket programming language} and
◊a[#:href "https://docs.racket-lang.org/pollen/"]{Pollen} for this homepage.} There is a
short ◊a[#:href "pollen.html"]{article} that describes the setup.

◊h1{Contact}

◊div{
  ◊b{email: } ◊a[#:href  "mailto:{first}.{last}@gmail.com"]{first.last@gmail.com}
}
◊div{
  ◊br{}
  ◊b{twitter: } ◊a[#:href  "https://twitter.com/burakemir"]{@burakemir}}

