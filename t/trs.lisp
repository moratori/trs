(in-package :cl-user)
(defpackage trs-test
  (:use :cl
        :trs.types
        :trs.util
        :trs.rename
        :trs.matching
        :trs.substitute
        :trs
        :prove))
(in-package :trs-test)

;; NOTE: To run this test file, execute `(asdf:test-system :trs)' in your Lisp.



(defun simple-match-driver (a b expected)
  (multiple-value-bind 
    (result flag) (simple-match a b)
    (when flag 
      (set= result expected #'matching=))))



(plan 5)




(subtest "#CONSTRUCTION TEST"
   (ok (fterm 'A (arglist nil)))
   (ok (vterm 'x))
   (ok (fterm 'f (arglist (list (vterm 'x) (vterm 'y) (fterm 'a (arglist nil)))))))



(subtest "#SIMPLE MATCH TEST"

   (ok (simple-match-driver (fterm 'a (arglist nil)) 
                            (fterm 'a (arglist nil))
                            nil))

   (ok (simple-match-driver (vterm 'x) 
                            (vterm 'y)
                            (list (matching (vterm 'x) (vterm 'y)))))

   (ok (simple-match-driver (vterm 'x) 
                            (fterm 'A (arglist nil))
                            (list (matching (vterm 'x) (fterm 'A (arglist nil))))))

   (ok (simple-match-driver (fterm 'a (arglist nil) ) 
                            (vterm 'x)
                            (list (matching (vterm 'x) (fterm 'A (arglist nil))))))

   (ok (simple-match-driver (fterm 'f (arglist (list (vterm 'x)))) 
                            (vterm 'x)
                            (list (matching (vterm 'x) (fterm 'f (arglist (list (vterm 'x))))))))

   (ok (simple-match-driver (fterm 'f (arglist (list (vterm 'x)))) 
                            (fterm 'f (arglist (list (vterm 'y))))
                            (list (matching (vterm 'x) (vterm 'y)))))

   (ok (simple-match-driver (fterm 'f (arglist (list (fterm 'g (arglist (list (vterm 'x))))))) 
                            (fterm 'f (arglist (list (fterm 'g (arglist (list (vterm 'y)))))))
                            (list (matching (vterm 'x) (vterm 'y)))))

   (ok (simple-match-driver (fterm 'f (arglist (list (fterm 'g (arglist (list (vterm 'x) (vterm 'a)))) 
                                                     (fterm 'h (arglist (list (vterm 'y))))))) 
                            (fterm 'f (arglist (list (vterm 'z) 
                                                     (fterm 'h (arglist (list (fterm 'b (arglist nil))))))))
                            (list (matching (vterm 'z) (fterm 'g (arglist (list (vterm 'x) (vterm 'a)))))
                                  (matching (vterm 'y) (fterm 'b (arglist nil))))))

   (ok (simple-match-driver (fterm 'f (arglist (list (vterm 'y) (vterm 'y))))
                            (fterm 'f (arglist (list (vterm 'x) (fterm 'A (arglist nil)))))
                            (list (matching (vterm 'y) (fterm 'a (arglist nil)))
                                  (matching (vterm 'x) (fterm 'a (arglist nil))))))

   (ok (simple-match-driver (fterm 'f (arglist (list (fterm 'A (arglist nil) ) (vterm 'x))))
                            (fterm 'f (arglist (list (vterm 'y) (vterm 'y))))
                            (list (matching (vterm 'y) (fterm 'a (arglist nil)))
                                  (matching (vterm 'x) (fterm 'a (arglist nil))))))

   (ok (not (simple-match-driver (fterm 'a (arglist nil)) 
                                 (fterm 'b (arglist nil))
                                 nil)))

   (ok (not (simple-match-driver (fterm 'a (arglist nil) ) 
                                 (fterm 'f (arglist (list (vterm 'x))))
                                 nil)))

   (ok (not (simple-match-driver (vterm 'x) 
                                 (fterm 'f (arglist (list (vterm 'x))))
                                 nil)))

   (ok (not (simple-match-driver (fterm 'f (arglist (list (vterm 'x)))) 
                                 (fterm 'a (arglist nil))
                                 nil)))

   (ok (not (simple-match-driver (fterm 'f (arglist (list (vterm 'x)))) 
                                 (fterm 'g (arglist (list (vterm 'y))))
                                 nil)))
   
   (ok (not (simple-match-driver (fterm 'f (arglist (list (vterm 'x) (fterm 'a(arglist nil))))) 
                                 (fterm 'f (arglist (list (vterm 'y) (fterm 'b(arglist nil)))))
                                 nil)))

   (ok (not (simple-match-driver (fterm 'f (arglist (list (fterm 'a(arglist nil) )))) 
                                 (fterm 'f (arglist (list (vterm 'y) (fterm 'b(arglist nil)))))
                                 nil)))

   (ok (not (simple-match-driver (fterm 'f (arglist (list (vterm 'x) (vterm 'x)))) 
                                 (fterm 'f (arglist (list (fterm 'a (arglist nil)) (fterm 'b (arglist nil)))))
                                 nil))))



(subtest "#SUBSTITUTE TEST"
   (let ((m (simple-match
              (fterm 'f (arglist (list (fterm 'g (arglist (list (vterm 'x) (fterm 'a(arglist nil) )))) 
                                       (fterm 'h (arglist (list (vterm 'y))))))) 
              (fterm 'f (arglist (list (vterm 'z) (fterm 'h (arglist (list (fterm 'b(arglist nil) ))))))))))
     (ok (reduce 
           (lambda (r x) (substitute-term r x))
           m
           :initial-value (fterm 'f (arglist (list (vterm 'z) (fterm 'h (arglist (list (vterm 'y)))))))))))



(subtest "#COLLECT VTERM TEST"

   (ok
    (set=
      (list (vterm 'x) (vterm 'y))
      (collect-vterm-occurrence (fterm 'f (arglist (list (fterm 'g (arglist (list (vterm 'x) (fterm 'a (arglist nil))))) 
                                                         (fterm 'h (arglist (list (vterm 'y))))))))
      #'term=))
   
   )


(subtest "#REWRITE UNIQUE VTERM TEST"

   (ok (rename-vterm (equation (vterm 'x) (vterm 'y))))
   (ok (rename-vterm (equation (vterm 'x) (vterm 'x))))
   (ok (rename-vterm (equation (vterm 'x) (fterm 'f (arglist (list (fterm 'g (arglist (list (vterm 'x) (fterm 'a (arglist nil)))))
                                                                   (fterm 'h (arglist (list (vterm 'x))))))))))
   )



(finalize)


(sb-cover:report 
  (merge-pathnames #P"coverage/" 
                   (asdf:system-source-directory :trs)))
