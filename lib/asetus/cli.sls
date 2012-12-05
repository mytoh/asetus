
(library (asetus cli)
  (export
    runner)
  (import
    (rnrs)
    (match)
    (asetus commands))

  (begin

    (define (runner args)
      (match (cadr args)
        ("list"
         (list-settings args))))
    ))
