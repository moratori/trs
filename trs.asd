#|
  This file is a part of trs project.
  Copyright (c) 2016 moratori ()
|#

#|
  Author: moratori ()
|#

(in-package :cl-user)
(defpackage trs-asd
  (:use :cl :asdf))
(in-package :trs-asd)

(defsystem trs
  :version "0.1"
  :author "moratori"
  :license ""
  :depends-on 
              (

               ;; for coverage tool
               #+sbcl :sb-cover
               )
  :components ((:module "src"
                :around-compile 
                 (lambda (thunk)
                   (declare (optimize
                              (debug 3)
                              (safety 3)
                              (speed 0)
                              (space 0)
                              (compilation-speed 0)))
                   #+sbcl
                   (declaim (optimize 
                              (sb-cover:store-coverage-data 3)))
                   (funcall thunk))

                :components
                (
                 (:file "types")
                 (:file "util")
                 (:file "substitute")
                 (:file "rename")
                 (:file "matching")
                 (:file "trs")
                    )))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op trs-test))))
