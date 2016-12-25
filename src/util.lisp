(in-package :cl-user)
(defpackage trs.util
  (:use :cl
        :trs.types
        )
  (:export 
    :term=
    :matching=
    :set=
    ))
(in-package :trs.util)



(defgeneric term= (term1 term2)
  (:documentation "2つのtermオブジェクトの同値比較
                   @param term1 termオブジェクト
                   @param term2 termオブジェクト
                   @return 真偽値")
  (:method ((t1 vterm) (t2 vterm))
    (eq (vterm.sym t1) (vterm.sym t2)))
  (:method ((t1 fterm) (t2 fterm))
    (and 
      (eq (fterm.f t1) (fterm.f t2))
      (every #'term= (arglist.list (fterm.args t1))
                     (arglist.list (fterm.args t2)))))
  (:method ((t1 t) (t2 t)) nil))


(defgeneric matching= (m1 m2)
  (:documentation "matchingオブジェクトの等値性を確認する")
  (:method ((m1 matching) (m2 matching))
   (and 
     (term= (matching.left m1)
            (matching.left m2))
     (term= (matching.right m1)
            (matching.right m2)))))


(defun set= (a b pred)
  (and 
    (null (set-difference a b :test pred))
    (null (set-difference b a :test pred))))
