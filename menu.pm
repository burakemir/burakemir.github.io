#lang pollen

◊(define (make-link page)
  `(a ((href ,(cadr page))) ,(car page)))
  
◊(define (menu active)

  `(p (ul ((class "menu"))
,@(for/list ([page '(("Home" "index.html")
                     ("Research" "research.html")
		     ("About" "about.html")
		     ("Blog" "blog.html"))])

  (if (equal? (car page) active)
     `(li ((class "active")) ,(make-link page))
     `(li ,(make-link page)))))))
