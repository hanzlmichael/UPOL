(defun solution3 (arr)
  (let* ((new arr)
         (sorted-count 0)
         (size (length arr))
         (barrier (counting-barrier (- size 1)))
         (mutex (semaphore 1)))
    (pdotimes (i (- size 1))
              (loop while (< sorted-count (- size 1)) do
                    (setf sorted-count 0)
                    (wait-on-barrier barrier)
                    (if (evenp i)
                        (progn 
                          (wait-on-barrier barrier)
                          (if (> (aref new i) (aref new (+ i 1)))
                              (rotatef (aref new i) (aref new (+ i 1)))
                            (progn 
                              (wait-on-semaphore mutex)
                              (incf sorted-count)
                              (signal-semaphore mutex)))
                          (wait-on-barrier barrier))
                      (progn
                        (if (> (aref new i) (aref new (+ i 1)))
                            (rotatef (aref new i) (aref new (+ i 1)))
                          (progn 
                            (wait-on-semaphore mutex)
                            (incf sorted-count)
                            (signal-semaphore mutex)))
                        (wait-on-barrier barrier)))))    
    new))