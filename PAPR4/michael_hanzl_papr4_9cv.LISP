(in-package :papr4/user)

(defclass pvector ()
  ((buffer :initform (make-array 1) :initarg :len)
   (capacity :initform 1 :initarg :capacity)
   (mutexes :initform (make-array 1 :initial-element (semaphore 1)) :initarg :mutexes)))

(defmethod read-vector ((v pvector) index)
  (with-slots (buffer mutexes) v
    (wait-on-semaphore (aref mutexes index))
    (aref buffer index)
    (signal-semaphore (aref mutexes index))))

(defmethod write-vector ((v pvector) index value)
  (with-slots (buffer mutexes) v
    (wait-on-semaphore (aref mutexes index))
    (setf (aref buffer index) value)
    (signal-semaphore (aref mutexes index))))

(defun pvector (capacity)
  (make-instance 'pvector :capacity capacity :len (make-array capacity) :mutexes (make-array capacity :initial-element (semaphore 1))))

(defun nmapv (fun vector &optional threads-count)
  (when (null threads-count)
    (setf threads-count 10))
  (with-slots (buffer) vector
    (pdotimes (i threads-count)
      (let ((index i))
        (loop :while (< index (length buffer)) 
              :do (progn 
                    (write-vector vector index (funcall fun (aref buffer index)))
                    (setf index (+ index threads-count)))))))
  vector)