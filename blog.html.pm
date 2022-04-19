#lang pollen
◊(require txexpr)
◊(require pollen/decode)
◊(require "menu.pm")

◊(define-meta title "Burak Emir's homepage : Blog")
◊(define-meta page-kind homepage)

◊(define (linked-posts u+href*)
  `(ul 
    ,@◊(for/list ([u+href (in-list u+href*)])
      `(li (a ((href ,(cadr u+href))) ,(car u+href))))))

◊(menu "Blog")

   ◊p{My (sparse) blog is at ◊a[#:href "https://blog.burakemir.ch"]{blog.burakemir.ch}}
   ◊p{Here is an index to some of those posts.
           ◊ul{
               ◊li{
                   ◊a[#:href "https://blog.burakemir.ch/2021/12/worked-example-of-automata-runs-as.html"]{
                     (2021) Worked example of automata runs as sheaves}}
               ◊li{
                   ◊a[#:href "https://blog.burakemir.ch/2021/01/what-are-commuting-conversions.html"]{
                     (2021) What are Commuting Conversions}}
               ◊li{
                   ◊a[#:href "https://blog.burakemir.ch/2020/07/relating-partial-evaluation-multi-stage.html"]{
                           Relating partial evaluation, multi-stage programming and macros}}
               ◊li{(2020) Intuitionistic Logic:
                 ◊(linked-posts '(
                   ("Intuitionistic Propositional Logic and Natural Deduction"
                    "https://blog.burakemir.ch/2020/05/intuitionistic-propositional-logic-and.html")
                   ("Kripke semantics and Tableaux for Intuitionistic Logic"
                    "https://blog.burakemir.ch/2020/06/kripke-semantics-and-tableaux-for.html"))
                               )}
               
               ◊li{(2020) Higher-order Logic:
                 ◊(linked-posts '(
                   ("Higher-order Logic and Equality"
                    "https://blog.burakemir.ch/2020/04/higher-order-logic-and-equality.html")
                   ("Intuitionistic Higher-Order Logic and Equality"
                    "https://blog.burakemir.ch/2020/09/intuitionistic-higher-order-logic-and.html")))}
               ◊li{
                   ◊a[#:href "https://blog.burakemir.ch/2010/12/yacc-is-of-living-dead.html"]{(2010) Yacc is of the Living Dead}
                   }
}}
