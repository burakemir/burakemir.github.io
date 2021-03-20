#lang scribble/html
@require["templates.rkt"]

@doctype{html}
@html[lang: "en"]{
 @header{Research}
 @body[id: "pn-top"]{
  @navbar{Research}
  @div[class: "jumbotron"]{
   @div[class: "container"]{
    @div[class: "row"]{
     @div[class: "col-md-12"]{
      
      @div[class: "main"]{
       @h1{Research}}}}}}}
 @div[class: "container"]{
  @div[class: "row"]{
   @h2{Pattern Matching}
  }
  @div[class: "row"]{
   @p{I studied Programming Languages in Martin Odersky's group at EPFL. Ever since, I remain enthusiastic
    about programming language technology. @a[href:"https://dblp.uni-trier.de/pers/hd/e/Emir:Burak"]{dblp}
  }}
  @div[class: "row"]{
   @p{Pattern matching was my thesis topic Here are some publications about it (the linked
    technical reports correspond exactly to the conference papers):}
  }
  @div[class: "row"]{
   @p{ @ul{
     @li{Burak Emir. @a[href:"https://infoscience.epfl.ch/record/109881"]{
       Object-oriented pattern matching.} Thesis, EPFL Lausanne. }
     @li{Burak Emir, Martin Odersky, John Williams. 
      @a[href:"https://infoscience.epfl.ch/record/98468"]{Matching objects with patterns.}  ECOOP 2007. }
     @li{Burak Emir, Qin Ma, Martin Odersky. @a[href:"https://infoscience.epfl.ch/record/108817?ln=en"]{
       Translation Correctness for First-Order Object-Oriented Pattern Matching}. APLAS 2007
  }}}}
  @div[class: "row"]{
   @h2{Constrained Polymorphism}
  }
  @div[class: "row"]{
   @p{During an internship at Microsoft Research in Cambridge, I got to apply some Scala techniques to C#.
    Here is a publication that describes that work (which made it into C# 4.0 later). }
  }
  @div[class: "row"]{
   @p{
    @ul{
     @li{Burak Emir, Andrew Kennedy, Claudio Russo, Dachuan Yu. @a[href:"https://www.microsoft.com/en-us/research/publication/variance-and-generalized-constraints-for-c-generics/"]{
       Variance and Generalized Constraints for C# generics}. ECOOP 2006}}}
  }
  @div[class: "row"]{
   @h2{Symbolic Execution}
  }
  @div[class: "row"]{
   @p{I hosted @a[href:"http://www.stefanbucur.net/"]{Stefan Bucur} as intern on a project related to 
    @a[href:"http://cloud9.epfl.ch/people"]{Cloud9}. Our results were negative and although we wrote them
    up, they did not get published.
  }}
  @footer{}}}
