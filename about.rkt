#lang scribble/html
@require["templates.rkt"]

@doctype{html}
@html[lang: "en"]{
 @header{About}
 @body[id: "pn-top"]{
  @navbar{About}
  @subpage-title{About}

  @div[class: "pn-main-wrapper"]{
   @div[class: "content"]{
    @div[class: "container"]{
     @div[class: "row"]{
      @h2{Contact}

     }
     @div[class: "row"]{
      @b{email: } @a[href: "mailto:burak DOT emir AT gmail DOT com"]{burak DOT emir AT gmail DOT com}
     }
     @div[class: "row"]{
      @br{}
      @b{twitter: } @a[href: "https://twitter.com/burakemir"]|{@burakemir}|

  }}}}
  @footer{}
}}

