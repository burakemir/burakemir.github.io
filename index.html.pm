#lang pollen
◊(require txexpr)
◊(require pollen/decode)
◊(require "menu.pm")
◊(define-meta title "Burak Emir's homepage")
◊(define (root . xs)
  xs)
  
◊(menu "Home")

◊section{
	◊img[#:src "BurakEmir-2007-04-23.jpg" #:alt "an old picture of Burak Emir"]{
}

◊h1{Burak Emir}

  ◊p{... enthusiastic about programming language technologies and large distributed systems.}
  ◊p{... lives in Zurich, Switzerland with my wife and two daughters}
  ◊p{... works at Google as "Alchemist of Happiness"}
  ◊p{Things you will find here: 
   ◊ul{
    ◊li{Links to research and publications}
    ◊li{Posts about programming,}
    ◊li{and other interests of mine, like my educational software project
     ◊a[#:href "http://google.github.io/arrow-logo/"]{arrow-logo} which
     you can try out ◊a[#:href "arrowlogo/ArrowLogo.html"]{here}.}}}}