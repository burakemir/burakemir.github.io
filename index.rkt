#lang scribble/html
@require["templates.rkt"]

@doctype{html}
@html[lang: "en"]{
 @header{Home}
 @body[id: "pn-top"]{
  @navbar{Home}
  @div[class: "jumbotron"]{
   @div[class: "container"]{
    @div[class: "row"]{
     @div[class: "col-md-12"]{
      @img[src: "BurakEmir-2007-04-23.jpg" alt: "an old picture of myself"]{
       @div[class: "main"]{
        @h1{Burak Emir}}}}}}}}
 @div[class: "container"]{
  @p{... enthusiastic about programming language technologies and large distributed systems.}
  @p{... lives in Zurich, Switzerland with my wife and two daughters}
  @p{... works at Google as "Alchemist of Happiness"}
  @p{Things you will find here: 
   @ul{
    @li{Links to research and publications}
    @li{Posts about programming,}
    @li{and other interests of mine, like my educational software project
     @a[href:"http://google.github.io/arrow-logo/"]{arrow-logo} which
     you can try out @a[href:"arrowlogo/ArrowLogo.html"]{here}.}}}
  @footer{}}}

