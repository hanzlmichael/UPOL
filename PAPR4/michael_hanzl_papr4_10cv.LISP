(in-package :papr4/user)

(defclass labour ()
  ((futures :initform nil)))

(defmethod set-worker-count ((labour labour) count)
  (with-slots (futures) labour
    (setf futures (gener-list count (lambda () (make-instance 'future))))
    nil))

(defmethod compute ((labour labour) fun)
  (with-slots (futures) labour
    (mapcar (lambda (x) 
              (setf (fun x) fun)
              (signal-semaphore (start x)))
            futures)
    futures))
  
(defclass future ()
  ((start :initform (semaphore 0) :accessor start)
   (fun :initform nil :accessor fun)
   (turnstile :initform (semaphore 0))
   (result :initform nil)))

(defmethod initialize-instance ((future future) &key)
  (call-next-method)
  (thread (f-compute future)))

(defmethod f-compute ((future future))
  (with-slots (start fun turnstile result) future
    (wait-on-semaphore start)
    (setf result (funcall fun))
    (signal-semaphore turnstile)))

(defmethod deref ((future future))
  (with-slots (turnstile result) future
    (wait-on-semaphore turnstile)
    (signal-semaphore turnstile)
    result))

(defun gener-list (n &optional fun)
  (cond ((> n 0) (let ((x nil))
                   (when fun
                     (setf x (funcall fun)))
                   (cons x (gener-list (- n 1) fun))))
        (t nil)))