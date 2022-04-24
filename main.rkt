(module kal racket/base
  (require (for-syntax racket/base)
           racket/generator
           racket/format
           racket/match)
  
  (provide (except-out 
             (all-from-out racket/base) 
             let define begin #%module-begin)
           loop 
           fn 
           send 
           handle 
           for
           continue
           log 
           (rename-out [module-begin #%module-begin]
                       [define let]
                       [kal-begin begin]))

  (define-syntax-rule (module-begin expr ...)
    (#%module-begin
      (kal-begin expr ...)))

  (define-for-syntax (begin-until-break-or-continue stmts)
    (cond
      [(null? stmts) '()]
      [(eq? (car (syntax->datum (car stmts))) 'break)
       (syntax-case (car stmts) (with)
         [(break) #''()]
         [(break with value) #'(value)])]
      [(eq? (car (syntax->datum (car stmts))) 'continue)
       (list (car stmts))]
      [else (cons
              (car stmts)
              (begin-until-break-or-continue (cdr stmts)))]))
  
  (define-syntax (kal-begin stx)
    (datum->syntax stx 
      (cons 'begin
        (begin-until-break-or-continue
         (cdr (syntax->list stx))))))
  
  (define-syntax-rule (loop body ...)
    (let lp () 
      (kal-begin
        body ... 
        (lp))))
  
  (define-syntax (fn stx)
    (syntax-case stx ()
      [(_ sig body ...)
       #`(define sig
             (generator ()
               (kal-begin
                 body ...)))]))
  
  (define-syntax (send stx)
    (syntax-case stx (with)
      [(send signal)
       #'(yield (list 'signal))]
      [(send signal with values ...) 
       #'(yield (list 'signal values ...))]))
  
  (define (log . v)
    (displayln (apply ~a v)))
  
  (define-syntax (continue stx)
    (syntax-case stx (with)
      [(continue) 
       #'((current-lp))]
      [(continue with values ...)
       #'((current-lp) values ...)]))
  
  (define current-lp (make-parameter #f))
  
  (define-syntax (handle stx)
    (syntax-case stx ()
      [(_ kal-gen clauses ...)
       #`(let ([gen kal-gen])
          (let lp ([signal (gen)])
            (current-lp 
              (lambda continue-args
                (lp (apply gen continue-args))))
            (match signal
              #,@(map
                (lambda (clause)
                  (syntax-case clause ()
                    [((received-signal values ...) rest ...)
                     #'[(list 'received-signal values ...) 
                        (kal-begin rest ...)]]))
                (syntax->list #'(clauses ...)))
              [else (yield signal)])))]))
  
  (define-syntax-rule (for ([var gen]) body ...)
    (handle gen
      [(yield var)
       body ...
       (continue)])))

