#|
  This file is a part of trs project.
  Copyright (c) 2016 moratori ()
|#

(in-package :cl-user)
(defpackage trs-test-asd
  (:use :cl :asdf))
(in-package :trs-test-asd)

(defsystem trs-test
  :author "moratori"
  :license ""
  :depends-on (:trs
               :prove
               #+sbcl 
               :sb-cover
                )
  :components ((:module "t"
                :components
                ((:test-file "trs"))))
  :description "Test system for trs"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
