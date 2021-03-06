(in-package :papr4/user)

(defclass barbershop ()
  ((n :initform 4)
   (customers :initform 0)
   (mutex :initform (semaphore 1))
   (customer :initform (semaphore 0))
   (barber :initform (semaphore 0))
   (customer-done :initform (semaphore 0))
   (barber-done :initform (semaphore 0))))

(defmethod n ((b barbershop))
  (slot-value b 'n))
(defmethod customers ((b barbershop))
  (slot-value b 'customers))
(defmethod mutex ((b barbershop))
  (slot-value b 'mutex))
(defmethod customer ((b barbershop))
  (slot-value b 'customer))
(defmethod customer-done ((b barbershop))
  (slot-value b 'customer-done))
(defmethod barber-done ((b barbershop))
  (slot-value b 'barber-done))  

(defmethod customer ((b barbershop))
  (wait-on-semaphore mutex)
  (if (= (b customers) (b n))
      (progn 
        (signal-semaphore (b mutex))
        (format t "balk")))
  (incf (customers b))
  (signal-semaphore (mutex b))
  (signal-semaphore (customer b))
  (wait-on-semaphore (barber b))
  (format t "getHairCut")
  (signal-semaphore (customer-done b))
  (wait-on-semaphore (barber-done b))
  (wait-on-semaphore (mutex b))
  (decf (customers b))
  (signal-semaphore mutex))

(defmethod barber ((b barbershop))
  (wait-on-semaphore (customer b))
  (signal-semaphore (barber b))
  (format t "CutHair")
  (wait-on-semaphore (customer-done b))
  (signal-semaphore (barber-done b)))

