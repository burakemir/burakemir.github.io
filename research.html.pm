#lang pollen
◊(require txexpr)
◊(require pollen/decode)
◊(require "menu.pm")

◊(define-meta title "Burak Emir's homepage : Research")
◊(define-meta page-kind homepage)

◊(menu "Research")

◊h1{Research}

◊section{
 ◊div{  
  ◊div{
   ◊p{I studied programming languages in Martin Odersky's group at EPFL and worked on Scala, specifically pattern matching.
           ◊a[#:href "https://dblp.uni-trier.de/pers/hd/e/Emir:Burak"]{dblp}}
   ◊p{After I joined Google, I continued my study formal logic, type theory and category theory for programming and specifying program behavior.}

   ◊p{Here are some artifacts:}}}
  
  ◊h2{Pattern Matching}

  ◊p{Pattern matching and ML-style algebraic data types are now part of rust, Java and python3.}

  ◊div{
   ◊p{
      ◊ul{
          ◊li{Burak Emir.
                    ◊a[#:href "https://infoscience.epfl.ch/record/109881"]{
                    Object-oriented pattern matching.} Thesis, EPFL Lausanne, 2007. }
          ◊li{Burak Emir, Martin Odersky, John Williams. 
                    ◊a[#:href "https://infoscience.epfl.ch/record/98468"]{Matching objects with patterns.}  ECOOP 2007. }
          ◊li{Burak Emir, Qin Ma, Martin Odersky.
                    ◊a[#:href "https://infoscience.epfl.ch/record/108817?ln=en"]{
                    Translation Correctness for First-Order Object-Oriented Pattern Matching}. APLAS 2007}}}}
  ◊div{
                     ◊h2{Constrained Polymorphism}}
  ◊div{
   ◊p{During an internship at Microsoft Research in Cambridge, I got to apply some Scala techniques to C#.
             The results are described here: }}
  ◊div{
   ◊p{
      ◊ul{
          ◊li{Burak Emir, Andrew Kennedy, Claudio Russo, Dachuan Yu.
                    ◊a[#:href "https://www.microsoft.com/en-us/research/publication/variance-and-generalized-constraints-for-c-generics/"]{
                                                                                                                                         Variance and Generalized Constraints for C# generics}. ECOOP 2006}}}
   ◊p{Variance annotations made it into C# 4.0 later.} 
   }
  ◊div{◊h2{Symbolic Execution}}
  ◊div{
    ◊p{At Google (2010?), I got a 20% intern sponsorship to host
      ◊a[#:href "http://www.stefanbucur.net/"]{Stefan Bucur} on a project related to 
      ◊a[#:href "http://cloud9.epfl.ch/people"]{Cloud9}. We tried symbolic execution as an
                           alternative to fuzzing to look for vulnerabilities in Chrome. This did not work well at the time,
                           though we learned a lot (this was before Google had a consistent cloud offering). Stefan
                           joined Google later and is working in security.
                           }}

  ◊div{◊h2{Systems, Languages, Types, Logic}}

  ◊p{There are many kinds of scientific and theoretical knowledge that have deep practical applications.} 

  ◊p{This is especially true in the context of distributed systems. I am preparing a few artifacts around these topics that I will publish here.}
}