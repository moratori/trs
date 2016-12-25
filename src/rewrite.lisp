(in-package :cl-user)
(defpackage trs.rewrite
  (:use :cl
        :trs.types
        :trs.util
        :trs.substitute
        :trs.rename
        :trs.matching
        )
  (:export 
    )
  )
(in-package :trs.rewrite)






(defmethod rewrite ((t1 vterm) rule-list)
  
  )


(defmethod rewrite ((t1 fterm) rule-list)
  
  )
