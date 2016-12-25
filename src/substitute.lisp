(in-package :cl-user)
(defpackage trs.substitute
  (:use :cl
        :trs.types
        :trs.util
        )
  (:export 
    :substitute-term
    ))
(in-package :trs.substitute)




(defgeneric substitute-term (term matching)
  (:documentation "term中に出現するすべてのmatchingのleftをmatchingのrightに置き換える
                   @param term termオブジェクト
                   @param matching matchingオブジェクト
                   @return termオブジェクト")
  (:method ((term vterm) (m matching))
   (if (term= term (matching.left m))
     (matching.right m)
     term))
  (:method ((term fterm) (m matching))
   (fterm (fterm.f term)
          (arglist
            (mapcar 
              (lambda (x)
                (substitute-term x m))
              (arglist.list (fterm.args term)))))))
