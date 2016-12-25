
(in-package :cl-user)
(defpackage trs.types
  (:use :cl)
  (:export 
     :term
     :vterm
     :vterm.sym
     :fterm 
     :fterm.f
     :fterm.args
     :arglist
     :arglist.list
     :matching
     :matching.left
     :matching.right
     :equation
     :equation.left
     :equation.right
     :rule
     :rule.left
     :rule.right
    ))
(in-package :trs.types)



(defstruct term 
  
  )



(defstruct (vterm
             (:include term)
             (:conc-name vterm.)
             (:constructor vterm (sym))
             (:print-object 
               (lambda (object stream)
                 (format stream "~A" (vterm.sym object)))))
  (sym nil :type symbol))


(defstruct (arglist 
             (:conc-name arglist.)
             (:constructor arglist (list)))
  ;; all element in the list is term type
  (list nil :type list))


(defstruct (fterm 
             (:include term)
             (:conc-name fterm.)
             (:constructor fterm (f args))
             (:print-object 
               (lambda (object stream)
                 (format stream "~A(~{~A~^,~})" (fterm.f object)
                                              (arglist.list (fterm.args object))))))
  (f nil :type symbol)
  (args (arglist nil) :type arglist))





(defstruct (matching 
             (:conc-name matching.)
             (:constructor matching (left right))
             (:print-object 
               (lambda (object stream)
                 (format stream "~A > ~A" (matching.left object)
                                             (matching.right object)))))
  (left  (error "initial value required") :type term)
  (right (error "initial value required") :type term))





(defstruct (equation
             (:conc-name equation.)
             (:constructor equation (left right))
             (:print-object 
               (lambda (object stream)
                 (format stream "~A = ~A" (equation.left object)
                                             (equation.right object)))))
  (left  (error "initial value required") :type term)
  (right (error "initial value required") :type term))


(defstruct (rule
             (:conc-name rule.)
             (:constructor rule (left right))
             (:print-object 
               (lambda (object stream)
                 (format stream "~A -> ~A" (rule.left object)
                                             (rule.right object)))))
  (left  (error "initial value required") :type term)
  (right (error "initial value required") :type term))




