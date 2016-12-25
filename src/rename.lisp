(in-package :cl-user)
(defpackage trs.rename
  (:use :cl
        :trs.types
        :trs.util
        :trs.substitute
        )
  (:export 
    :rename-vterm
    :collect-vterm-occurrence
    ))
(in-package :trs.rename)


(defparameter +variable-prefix+ "v_")



(defgeneric collect-vterm-occurrence (term)
  (:documentation "項中に出現するvtermを集める
                   @param term termオブジェクト
                   @return vtermオブジェクトのリスト")
  (:method ((t1 vterm)) (list t1))
  (:method ((t1 fterm)) 
   (loop 
     for arg in (arglist.list (fterm.args t1))
     append (collect-vterm-occurrence arg))))





(defgeneric rename-vterm (equation)
  (:documentation "式中の変数をgensymで作成した変数に置きける
                   @param equation 等式オブジェクト
                   @return 等式オブジェクト"))

(defmethod rename-vterm ((e equation))
  (let* ((left-vterms  (collect-vterm-occurrence (equation.left e)))
         (right-vterms (collect-vterm-occurrence (equation.right e)))
         (vterms (remove-duplicates 
                   (append left-vterms right-vterms)
                   :test #'term=))
         (matching-list 
           (mapcar 
             (lambda (x) (matching x (vterm (gensym +variable-prefix+))))
             vterms)))
    (equation
      (reduce 
        (lambda (r x)
          (substitute-term r x))
        matching-list
        :initial-value (equation.left e))
      (reduce 
        (lambda (r x)
          (substitute-term r x))
        matching-list
        :initial-value (equation.right e)))))


(defmethod rename-vterm ((e rule))
  (let* ((left-vterms  (collect-vterm-occurrence (rule.left e)))
         (right-vterms (collect-vterm-occurrence (rule.right e)))
         (vterms (remove-duplicates 
                   (append left-vterms right-vterms)
                   :test #'term=))
         (matching-list 
           (mapcar 
             (lambda (x) (matching x (vterm (gensym +variable-prefix+))))
             vterms)))
    (rule
      (reduce 
        (lambda (r x)
          (substitute-term r x))
        matching-list
        :initial-value (rule.left e))
      (reduce 
        (lambda (r x)
          (substitute-term r x))
        matching-list
        :initial-value (rule.right e)))))


