(in-package :cl-user)
(defpackage trs.matching
  (:use :cl
        :trs.types
        :trs.util
        :trs.substitute
        :trs.rename
        )
  (:export 
    :simple-match
    )
  )
(in-package :trs.matching)



(defgeneric simple-match (term1 term2)
  (:documentation "２つのtermオブジェクトの間の単一化子を求める
                   @param term1 termオブジェクト
                   @param term2 termオブジェクト
                   @return (values 単一化子のリスト 単一化成功フラグ)"))


(defmethod simple-match ((t1 term) (t2 term))
    (handler-case 
      (let ((init (list (matching t1 t2))))
        (loop
          named exit
          for e-ff-fv = (unfold-ff-fv% init)
          for e-vf-vv = (unfold-vf-vv% e-ff-fv)
          do 
          (when (set= init e-vf-vv #'matching=) 
            (setf init e-vf-vv)
            (return-from exit nil))
          (setf init e-vf-vv))
        (values init t))
      (condition (c)
        (declare (ignore c))
        (values nil nil))))


(defun unfold-ff-fv% (e)
  "e中の単一化子について、左辺が関数項であるものの展開を行う
   両辺が関数項であるならば、引数をzipしてeに追加する
   右辺が関数項でないならば、左辺と右辺を入れ替えてeに追加する
   @param e matchingオブジェクトのリスト
   @return matchingオブジェクトのリスト"
  (let (result)
    (loop 
      for m in e
      for left  = (matching.left m)
      for right = (matching.right m)
      do 
      (cond 
        ((and (typep left 'fterm) (typep right 'fterm))
         (let ((leftsym (fterm.f left))
               (rightsym (fterm.f right))
               (leftargs (arglist.list (fterm.args left)))
               (rightargs (arglist.list (fterm.args right))))
           (when (or (not (eq leftsym rightsym))
                     (not (= (length leftargs) (length rightargs))))
             (error "fterm matching failed"))
           (loop 
             for t1 in leftargs
             for t2 in rightargs
             do (push (matching t1 t2) result))))
        ((and (typep left 'fterm) (typep right 'vterm))
         (push (matching right left) result))
        (t 
         (push m result))))
    result))


(defun unfold-vf-vv% (e)
  "e中の単一化子について、左辺が変数項であるものの展開を行う
   右辺が関数項であるならば、出現チェックを行いe中の単一化子のすべてに適用する
   右辺が変数校であるならば、e中の単一化子のすべてに適用する
   @param e matchingオブジェクトのリスト
   @return matchingオブジェクトのリスト"
  (let ((m 
          (find-if 
            (lambda (m)
              (some 
                (lambda (x)
                  (and 
                    (not (matching= x m))
                    (or 
                      (find (matching.left m) (collect-vterm-occurrence (matching.left x))  :test #'term=)
                      (find (matching.left m) (collect-vterm-occurrence (matching.right x)) :test #'term=))))
                e))
            e)))

    (if m
      (progn 
        (when (and (typep (matching.right m) 'fterm)
                   (find  (matching.left m) 
                          (collect-vterm-occurrence (matching.right m)) :test #'term=))
          (error "occurrencec check failed"))
        (mapcar
          (lambda (x)
            (if (matching= m x) m
              (matching 
                (substitute-term (matching.left x) m)
                (substitute-term (matching.right x) m)))) e))
      e)))


