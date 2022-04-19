<!DOCTYPE html>


◊(define page-title (select-from-metas 'page-title metas))
◊(define page-kind (select-from-metas 'page-kind metas))

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>◊|page-title|</title>
  ◊when/splice[(eq? page-kind 'homepage)]{
    <link rel="stylesheet" href="/homepage.css">
    <script type="text/javascript" src="hilbert.js" defer="true"></script>
  }
  ◊when/splice[(eq? page-kind 'article)]{
    <link rel="stylesheet" href="/article.css">
    <script>
      MathJax = {
  loader: {load: ['[tex]/bussproofs']},
  tex: {
      inlineMath: [['$', '$'], ['\\(', '\\)']],
      packages: {'[+]': ['bussproofs']}
  },
  svg: {
    fontCache: 'global'
  }
};
</script>
<script type="text/javascript" id="MathJax-script" async
  src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js">
</script>
  }     
</head>
  ◊when/splice[(eq? page-kind 'homepage)]{
    <canvas id="hilbert"></canvas>
    ◊(->html doc)
  }     
  ◊when/splice[(eq? page-kind 'article)]{
    <article>
    ◊(->html doc)
    </article>
  }     
</html>
