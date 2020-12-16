(in-package :papr4/user)

(defclass safe-stack (monitor)
  ((items :initform nil)
   (occupiedp :initform (condition-variable))
   (poppers :initform 0)
   (no-poppers :initform (condition-variable))))

(define-monitor-method safe-push ((ss safe-stack) value)
  (with-slots (items occupiedp poppers no-poppers) ss
    (loop :while (> poppers 0)
          :do (wait-on-condition no-poppers))
    (push value items)
    (signal-condition occupiedp)))

(define-monitor-method safe-pop-enter ((ss safe-stack))
  (with-slots (items occupiedp poppers) ss
    (loop :while (< (length items) 1)
          :do (wait-on-condition occupiedp))
    (incf poppers)
    (pop items)))

(define-monitor-method safe-pop-leave ((ss safe-stack))
  (with-slots (poppers no-poppers) ss
    (decf poppers)
    (when (= poppers 0)
      (signal-condition no-poppers))))

(define-monitor-method safe-emptyp ((ss safe-stack))
  (with-slots (items) ss
    (if (null items) t nil)))

