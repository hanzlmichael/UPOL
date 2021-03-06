#|

DOKUMENTACE:

Vy�aduje soubory 05.lisp a 05_light.lisp

NOV� T��DY: 

;;;;;;;;;;;;;;;;;;;;;;
;;;;;;SEMAPHORE;;;;;;; 
;;;;;;;;;;;;;;;;;;;;;;

T��da semaphore je potomkem t��dy picture. Zobrazuje sv�tla v obdeln�ku, kter� 
vizualizuj� semafor. Po vytvo�en� instance je nastaven defaultn� na typ :vehicle 

UPRAVEN� ZD�D�N� VLASTNOSTI:
��dn�

NOV� VLASTNOSTI:
semaphore-type - uchov�v� v sob� �daj o typu semaforu, lze nastavovat i ��st
semaphore-phase - ud�v� v j�k� f�zi se semafor nach�z�
phase-count - ud�v� po�et f�z� semaforu (��slov�n� od 0)


UPRAVEN� ZD�D�N� ZPR�VY:
��dn�


NOV� ZPR�VY:

next-phase - p�ep�na jednotliv� f�ze semaforu


;;;;;;;;;;;;;;;;;;;;;;
;;;;;;CROSSROADS;;;;;; 
;;;;;;;;;;;;;;;;;;;;;;

- potomek t��dy picture, instance tvo�� k�i�ovatku, kterou lze p�ep�nat

UPRAVEN� ZD�D�N� VLASTNOSTI: 

��dn�

NOV� VLASTNOSTI:
crossroads-phase    - f�ze ve kter� se nach�z� k�i�ovatka 
phase-count         - ud�v� po�et f�z� k�i�ovatky (��slov�n� od 0)
semaphores          - vyp�e seznam v�ech semafor� v k�i�ovatce
program             - obsahuje program semaforu. To je seznam seznam�. Jeho d�lka ud�v� po�et f�z�, i-t� podseznam programu ur�uje stav k�i�ovatky 
                      v jej� i-t� f�zi. Ka�d� podseznam m� d�lku rovnou po�tu semafor� v k�i�ovatce a pro ka�d� semafor obsahuje ��slo jeho f�ze. 

UPRAVEN� ZD�D�N� ZPR�VY:
��dn�

NOV� ZPR�VY:
next-phase - p�ep�n�n� f�ze k�i�ovatky


|#


(defvar *semaphore-parametres*
  '((:vehicle
     ((15 15 45 75)
      ((t nil nil)
      (t t nil)
      (nil nil t)
      (nil t nil))
      (:red :orange :green)
      3))
    (:pedestrian
     ((15 15 45)
      ((t nil)
      (nil t))
      (:red :green)
      2))))
      

(defun get-parametres-from-var (type)
  (let  ((var nil))
    (dolist (n *semaphore-parametres*)
      (cond ((member type n) (setf var (first (rest n))))))
    var))

(defun get-xy (param-list)
  (first param-list))

(defun get-phases (param-list)
  (second param-list))

(defun get-colors (param-list)
  (third param-list))

(defun get-lights-count (param-list)
  (fourth param-list))

(defun set-on-colors (sem)
  (let* ((type (semaphore-type sem))
         (colors-list (get-colors (get-parametres-from-var type))))
    (dolist (n (items sem))
      (set-on-color n (first colors-list))
      (setf colors-list (rest colors-list))))
  sem)

      

;;;
;;; T��da semaphore
;;;

(defclass semaphore (picture)
 ((semaphore-type :initform :vehicle)
  (semaphore-phase :initform 0)))

(defmethod initialize-instance ((s semaphore) &key)
  (call-next-method)
  (let* ((type (semaphore-type s))
         (lights-count (get-lights-count (get-parametres-from-var type)))
         (output nil))
    (dotimes (n lights-count)
      (setf output (append output (list (make-instance 'light)))))
    (set-items s  output)
    (set-positions-of-lights s)
    (set-on-colors s)
    (add-borders s)
    (set-semaphore-phase s 0))
  s)
                         
(defmethod semaphore-type ((s semaphore))
  (slot-value s 'semaphore-type))

(defmethod set-semaphore-type ((s semaphore) value)
  (setf (slot-value s 'semaphore-type) value)
  (initialize-instance s)
  s)

(defmethod semaphore-phase ((s semaphore))
  (slot-value s 'semaphore-phase))

(defmethod set-semaphore-phase ((s semaphore) value)
  (setf (slot-value s 'semaphore-phase) value)
  (make-semaphore-phase s value)
  s)

(defmethod phase-count ((s semaphore))
  (length (get-phases (get-parametres-from-var (semaphore-type s)))))

(defmethod next-phase ((s semaphore))
  (let* ((type (semaphore-type s))
         (actual-phase (semaphore-phase s))
         (phases (get-phases (get-parametres-from-var type)))
         (phases-count (- (length phases) 1)))
    (cond ((equal actual-phase phases-count) (set-semaphore-phase s 0))
          (t (set-semaphore-phase s (+ 1 actual-phase))))))

;rozsv�t� sv�tla podle aktu�ln� f�ze 
(defun make-semaphore-phase (s value)
  (let* ((type (semaphore-type s))
         (phases (get-phases (get-parametres-from-var type)))
         (actual-phase (nth value phases)))
    (dolist (n (items s))
      (cond ((eql (type-of n) 'light) (set-onp n (first actual-phase))
             (setf actual-phase (rest actual-phase)))
            (t (setf actual-phase (rest actual-phase)))))))

(defun set-positions-of-lights (sem)
  (let* ((type (semaphore-type sem))
         (xy (get-xy (get-parametres-from-var type)))
         (x (first xy))
         (y (rest xy)))
    (dolist (n (items sem))
      (set-x (center n) x)
      (set-y (center n) (first y))
      (set-radius n 15)
      (setf y (rest y)))
    sem))      
    
(defun add-borders (sem)
  (set-items sem (append (items sem) (list (make-border sem)))))


;;;
;;; Or�mov�n� semaforu
;;;

(defun make-border (sem)
  (let* ((poly (set-filledp (make-instance 'polygon) t))
         (borders (borders sem)))
    (set-items poly borders)
    poly))

(defmethod borders ((s semaphore))
  (let ((location1 (first (items s)))
        (location2 (nth (- (length (items s)) 1) (items s))))
    (list (move (make-instance 'point) (left location1) (top location1))
          (move (make-instance 'point) (right location1) (top location1))
          (move (make-instance 'point) (right location2) (bottom location2))
          (move (make-instance 'point) (left location2) (bottom location2)))))


;;;
;;; T��da crossroads
;;;

(defclass crossroads (picture)
  ((crossroads-phase :initform nil)
   (program :initform nil)))

(defmethod program ((c crossroads))
  (slot-value c 'program))

(defmethod set-program ((c crossroads) value-list)
  (setf (slot-value c 'program) value-list)
  (setf (slot-value c 'crossroads-phase) 0)
  (let ((prog (first (program c))))
    (dolist (n (items c))
      (when (typep n 'semaphore)
        (set-semaphore-phase n (first prog))
        (setf prog (rest prog)))))
  c)

(defmethod phase-count ((c crossroads))
  (length (program c)))

(defmethod crossroads-phase ((c crossroads))
  (slot-value c 'crossroads-phase))

(defmethod set-crossroads-phase ((c crossroads) value)
  (if (= value (crossroads-phase c))
      c
    (let ((sem (semaphores c))
          (cr-prog (nth value (program c))))
      (dolist (n sem)
        (set-semaphore-phase n (first cr-prog))
        (setf cr-prog (rest cr-prog)))))
  (setf (slot-value c 'crossroads-phase) value)
  c)
    

(defmethod next-phase ((c crossroads))
  (if (= (+ 1 (crossroads-phase c)) (length (program c)))
      (set-crossroads-phase c 0)
    (progn
      (set-crossroads-phase c (+ 1 (crossroads-phase c)))
      (let ((cr-program (nth (crossroads-phase c) (program c)))
            (sem (semaphores c)))
        (dolist (n sem)
          (set-semaphore-phase n (first cr-program))
          (setf cr-program (rest cr-program))))
      c)))

(defmethod semaphores ((c crossroads))
  (let ((slots (slot-value c 'items))
        (result '()))
    (labels ((help (items)
               (cond ((null items) nil)
                     ((typep items 'semaphore) (push items result))
                     ((typep items 'picture) (help (slot-value items 'items)))
                     ((typep items 'crossroads) (help (slot-value items 'items)))
                     ((typep items 'shape) nil)
                     (t (remove-duplicates (append (help (car items))
                                (help (cdr items))))))))
      (help slots))
    (reverse result)))
      

    
#|

tests

(setf w (make-instance 'window)) 
(setf cr (make-instance 'crossroads))
(set-program cr '((0 0 0) (0 1 0) (0 2 1)))
(setf s1 (make-instance 'semaphore))
(setf s2 (move (make-instance 'semaphore) 40 0))
(setf s3 (move (make-instance 'semaphore) 80 0))
(set-items cr (list s1 s2 s3))
(set-shape w cr)
(redraw w)
(next-phase cr)

(set-shape w s1)
(setf c (move (set-radius (make-instance 'circle) 15) 15 15))
(setf ccc (move (set-radius (make-instance 'circle) 15) 15 75))

 (set-items pic (list (set-radius (move (make-instance 'light) 15 15) 15)
                      (set-radius (move (make-instance 'light) 15 45) 15)
                      (set-radius (move (make-instance 'light) 15 75) 15)))

(next-phase s1)
|#
    
    
    


       
        
 
