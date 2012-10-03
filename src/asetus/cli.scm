(define-module asetus.cli
  (export runner)
  (use gauche.parseopt)
  (use util.match)
  (use file.util)
  (use asetus.core)
  (use asetus.commands)
  )
(select-module asetus.cli)

(define runner
  (lambda (args)
    (let-args (cdr args)
      ((#f "h|help" (exit 0))
       . rest)
      (when (null-list? rest)
        (exit 0))
      (match (car  rest)
        ;; actions
        ("list"
         (list-settings (cadr rest)))
        (_ (exit 0))))))
