#lang scribble/html

@provide[
 header
 navbar
 footer
 subpage-title
 ]

@require[
 (only-in racket/list add-between)
 ]

@(define (comment . content)
   @literal[@list[" <!-- " content " --> "]])

@(define <!-- comment)

@(define (header title-str)
   @head{
 @meta[charset: "utf-8"]
 @meta[name: "viewport" content: "width=device-width, initial-scale=1, shrink-to-fit=no"]
 @link[rel:"stylesheet"
       href:"https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css"
       integrity:"sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS"
       crossorigin:"anonymous"]
 @script[async:"async" src:"https://www.googletagmanager.com/gtag/js?id=UA-46857206-1"]{
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'UA-46857206-1');
  }

 @title{@|title-str|}
 })

@(define (footer)
   @list{
 @script[src:"https://code.jquery.com/jquery-3.3.1.slim.min.js"
         integrity:"sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
         crossorigin:"anonymous"]
 @script[src:"https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js"
         integrity:"sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut"
         crossorigin:"anonymous"]
 @script[src:"https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js"
         integrity:"sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k"
         crossorigin:"anonymous"]
 })

@(define nav-template ; (Listof (List String String))
   '(("index.html" . "Home")
     ("research.html" . "Research")
     ("about.html" . "About")
     ("blog.html" . "Blog")
     ))

@(define (navbar current-page)

   (define rendered-nav-elements
     (for/list ([title-pair (in-list nav-template)])
       (if (string=? (cdr title-pair) current-page)
           @li[class: "nav-item active"]{@a[href: "#" class:"nav-link"]{@cdr[title-pair]}}
           @li[class: "nav-item"]{@a[href: @car[title-pair] class:"nav-link"]{@cdr[title-pair]}})))
   
   @element/not-empty['nav class: "navbar navbar-expand-lg navbar-light bg-light"]{
 @a[class:"navbar-brand" href:"#"]{b}
 @button[class:"navbar-toggler" type:"button" data-toggle:"collapse"
         data-target:"#navbarSupportedContent" aria-controls:"navbarSupportedContent" aria-expanded:"false"
         aria-label:"Toggle navigation"]{
  @span[class:"navbar-toggler-icon"]}

 @div[class:"collapse navbar-collapse" id:"navbarSupportedContent"]{
  @ul[class:"navbar-nav mr-auto" rendered-nav-elements] }})

@(define (subpage-title title)
   @div[class: "jumbotron subpages"]{
 @div[class: "container"]{
  @div[class: "row"]{
   @div[class: "col-md-12"]{
    @h1{@|title|}}}}})

