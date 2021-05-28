#lang pollen
◊(require txexpr)
◊(require pollen/decode)
◊(require "menu.pm")

◊(define-meta title "Burak Emir's homepage : About")

◊(menu "About")

◊h1{About}

◊p{I use ◊a[#:href="https://racket.org"]{racket} and ◊a[#:href "https://docs.racket-lang.org/pollen/"]{pollen} for this homepage.}

◊h1{Contact}

◊div{
  ◊b{email: } ◊a[#:href  "mailto:{first}.{last}@gmail.com"]{first.last@gmail.com}
}
◊div{
  ◊br{}
  ◊b{twitter: } ◊a[#:href  "https://twitter.com/burakemir"]{@burakemir}}

