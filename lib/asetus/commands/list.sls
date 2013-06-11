
(library (asetus commands list)
    (export
      list-settings)
  (import
    (silta base)
    (silta cxr)
    (only (srfi :1)
          remove)
    (only (srfi :13)
          string-take
          string-index
          string-ref
          string-trim-both)
    (srfi :48)
    (loitsu string)
    (loitsu file)
    (maali))

  (begin

    (define (comment? string-line)
      (cond
        ((= (string-length string-line) 0)
         #f)
        ((equal? #\# (string-ref (string-trim-both (string-trim-both string-line) #\t) 0))
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
                      (paint (string-trim-both (car e)) 31)
                      (paint (string-trim-both (cadr e)) 172))))
        lyst))

    (define (remove-inline-comment st)
      (if (string-index st #\#)
        (string-trim-both (string-take st (string-index st #\#)))
        st))


    (define (remove-if-statement lis)
      (let loop ([lis lis] [r '()])
           (cond
             ((null? lis) (reverse r))
             ((eof-object? (car lis)) (reverse r))
             ((string=? "if " (string-take (car lis) 3))
              (let remove-if ((ls (cdr lis)))
                   (cond
                     ((string=? "fi" (string-take (car ls) 2))
                      (loop (cdr ls) r))
                     (else
                         (remove-if (cdr ls))))))
             (else (loop (cdr lis) (cons (car lis) r))))))


    (define (file->settings file)
      (map
          (lambda (setting-and-value)
            (map
                (lambda (e) (string-trim-both  e #\"))
              (string-split setting-and-value #\=)))
        (remove-if-statement
         (remove
             (lambda (s)
               (or (comment? s) (empty-line? s) (null? s)))
           (file->string-list file)))))

    (define (list-settings args)
      (let ((setting-file (caddr args)))
        (print-for-each
         (file->settings setting-file))))


    ))
