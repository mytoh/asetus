(define-module asetus.commands.list
  (export list-settings)
  (use gauche.parseopt)
  (use gauche.process)
  (use gauche.sequence)
  (use util.match)
  (use file.util)
  (use srfi-13)
  (use srfi-1)

  (use maali)
  )
(select-module asetus.commands.list)


(define (comment? string-line)
  (cond
    ((= (string-length string-line) 0)
     #f)
    ((equal? #\# (~ (string-trim-both (string-trim-both string-line) #\t) 0))
     #t)
    (else #f)))

(define (empty-line? line)
  (if (string=? "" line)
    #t #f))

(define (print-for-each lyst)
  (for-each
    (lambda (e)
      (if (not (null? e))
        (format #t "~a: ~a\n"
                (paint (car e) 39)
                (paint (cadr e) 169))))
    lyst))

(define (remove-comment st)
  (if-let1 removed-string
    (string-scan st #\# 'before)
    (string-trim-both removed-string)
    st))


(define (remove-if-statement lis)
  (let loop ([lis lis] [r '()])
    (cond
      ((null-list? lis) (reverse r))
      ((eof-object? (car lis)) (reverse r))
      ((string=? "if " (subseq (car lis) 0 3))
       (let remove-if ((ls (cdr lis)))
         (cond
           ((string=? "fi" (subseq (car ls) 0 2))
            (loop (cdr ls) r))
           (else
             (remove-if (cdr ls))))))
      (else (loop (cdr lis) (cons (car lis) r))))))


(define (file->settings file)
  (map
    (lambda (setting-and-value)
      (map
        (lambda (e) (string-trim-both (remove-comment e) #\"))
        (string-split setting-and-value "=")))
    (remove-if-statement
      (remove
        (any-pred comment? empty-line? null?)
        (file->string-list file)))))

(define (list-settings setting-file)
  (print-for-each
    (file->settings setting-file)))
