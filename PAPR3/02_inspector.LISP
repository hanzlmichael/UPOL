#|
DOKUMENTACE: 

2. z�po�tov� �kol (INSPECTED a INSPECTOR WINDOW)

P�ed kompilac� je t�eba na��st soubor 05_bounds.lisp, 08.lisp, 08_text_shape

NOV� T��DY:

T��DA INSPECTED-WINDOW

T��da inspected-window je t��da, kter� reprezentuje prohl�en� okno, ve kter�m se pomoc� kliku vol� objekt jeho� informace budou zobrazeny v inspector-window. Je potomkem window.

NOV� VLASTNOSTI:

inspected-object - uchov�v� v sob� informace o prohl�en�m objektu, lze nastavovat i ��st

NOV� METODY (DOSA�ITELN� OD U�IVATELE)

-��dn�

P�EPSAN� METODY:

window-mouse-down - nastav� inspected-object na shape do kter�ho bylo kliknuto nebo ode�le event deleg�tovi


T��DA MY-TEXT-SHAPE

T��da my-text-shape je t��da, kter� reprezentuje jednu kolonku v�pisu v inspector-window, d�d� z text-shape a m� nav�c slot name

NOV� VLASTNOSTI: 

name - uchov�v� jm�no, lze nastavovat i ��st

NOV� METODY (DOSA�ITELN� OD U�IVATELE)
- ��dn�

P�EPSAN� METODY:

-��dn�

T��DA INSPECTOR-WINDOW

T��da inspector-window je t��da reprezentuj�c� prohl�e�, p�i vytvo�en� a p�i�azen� inspected window zobrazuje info  o tomto prohl�en�m okn�, jinak zobrazuje info o nakliknut�m objektu, je v n�m mo�no i m�nit hodnoty.

NOV� VLASTNOSTI:

inspected-window - dle zad�n�, uchov�v� v sob� odkaz na prohl�en� okno, lze nastavovat i ��st

NOV� METODY (DOSA�ITELN� OD U�IVATELE):

set-inspected-window - do slotu p�id� odkaz na okno, kter� bude prohl�eno

IMPLEMENTACE ZOBRAZEN� VLASTN�CH GRAFICK�CH OBJEKT� V INSPEKTORU:

Pokud by u�ivatel cht�l v prohl�e�i zobrazit informace o sv�m grafick�m objektu (nap�. bulls-eye), zm�n� solidp objektu na hodnotu true (cokoliv ne� nil) a pot� tento grafick� objekt naklikne, informace se automaticky zobraz� v inspectoru a lze je m�nit, v tomto p��pad� je mo�n� m�nit i hodnotu squarep p��mo z prohl�e�e.

(defmethod solidp ((be bulls-eye))
  t)
  

test:

#|
(setf inspector (make-instance 'inspector-window))
(setf inspected (make-instance 'inspected-window))
(setf c (move (set-radius (set-filledp (make-instance 'circle) t) 20) 70 70))
(set-inspected-window inspector inspected)
(set-shape inspected c)
|#



|#

;;; T��DA MY-TEXT-SHAPE

(defclass my-text-shape (text-shape)
  ((name :initform nil)))

(defmethod do-set-name ((mts my-text-shape) value)
  (setf (slot-value mts 'name) value)
mts)

(defmethod name ((mts my-text-shape))
  (slot-value mts 'name))

(defmethod set-name ((mts my-text-shape) value)
  (send-with-change mts
                    'do-set-name 'set-name
                    `(,value)))


;;; FUNKCE PRO VYTVO�EN� TEXTU

(defun method-name (property-name)
  (find-symbol (format nil "~a" property-name)))
  
(defun setter-name (property-name)
  (find-symbol (format nil "SET-~a" property-name)))

(defun display-info (object)
  (let* ((actual-ts nil)
         (output nil)
         (output-pic)
         (actual-fun nil)
         (obj-type (type-of object))
         (list-of-slots (append (list 'class-of) (mapcar #'slot-definition-name (class-slots (find-class obj-type))))))
    (dolist (n list-of-slots)
      (setf actual-ts (make-instance 'my-text-shape))
      (setf actual-fun (method-name n))
      (set-text actual-ts
                (format nil 
                        (concatenate 'string (string n) ": ~s") (funcall actual-fun object)))
      (set-name actual-ts n)
      (setf output (append  output (list actual-ts))))
    (setf output-pic (make-instance 'picture))
    (set-items output-pic output)))   

(defun set-up-position (pic)
  (let ((pic-items (items pic))
        (actual-y 0))   
    (dolist (n pic-items)
      (setf actual-y (+ actual-y 20))
      (move n 50 actual-y))
    pic))

;;; T��DA INSPECTED-WINDOW

(defclass inspected-window (window)
  ((inspected-object :initform nil)))

(defmethod inspected-object ((iw inspected-window))
  (slot-value iw 'inspected-object))

(defmethod do-set-inspected-object ((idw inspected-window) value)
  (setf (slot-value idw 'inspected-object) value))

(defmethod set-inspected-object ((idw inspected-window) value)
  (send-with-change idw
                    'do-set-inspected-object 'set-inspected-object
                    `(,value)))

(defmethod window-mouse-down ((idw inspected-window) button position)
  (let ((shape (find-clicked-shape idw position)))
    (if shape
        (mouse-down-inside-shape idw shape button position)
      (set-inspected-object idw idw))))

(defmethod ev-mouse-down ((iw inspected-window) sender origin button position)
  (set-inspected-object iw (find-clicked-shape iw position)))

;;; T��DA INSPECTOR-WINDOW

(defclass inspector-window (window)
  ((inspected-window :initform nil)))

(defmethod inspected-window ((iw inspector-window))
  (slot-value iw 'inspected-window))

(defmethod set-inspected-window ((iw inspector-window) value)
  (setf (slot-value iw 'inspected-window) value)
  (set-delegate (inspected-window iw) iw)
  (set-inspected-object (inspected-window iw) (inspected-window iw))
  iw)

(defmethod change ((irw inspector-window) message changed-obj args)
  (cond ((eql (type-of changed-obj) 'inspected-window)
         (let* ((idw (inspected-window irw))
                (idobject (inspected-object idw)))
           (set-shape irw (set-up-position (display-info idobject)))
           (invalidate irw)))
        (t (invalidate (inspected-window irw)))))

(defmethod ev-double-click ((irw inspector-window) sender origin button position)
  (when (eql (type-of origin) 'my-text-shape)
    (clicked-in-ts irw origin sender)))

(defun clicked-in-ts (irw origin sender)
  (let* ((ts-window (inspected-window irw))
         (id-object (inspected-object ts-window))
         (ts-name (name origin))
         (fun (setter-name ts-name))
         (prompt-list nil))
    (setf prompt-list (multiple-value-list (capi:prompt-for-value "Zadejte novou hodnotu")))
    (funcall fun id-object (first prompt-list)))
  (set-items sender (items (set-up-position (display-info (inspected-object (inspected-window irw))))))
  (invalidate irw))
  

;; NOV� KLIK�N�

(defmethod install-double-click-callback ((w inspector-window))
  (mg:set-callback 
   (mg-window w) 
   :double-click (lambda (mgw button x y)
                   (declare (ignore mgw))
                   (window-double-click 
                    w
                    button 
                    (move (make-instance 'point) x y)))))


(defmethod install-callbacks ((w inspector-window))
  (install-display-callback w)
  (install-mouse-down-callback w)
  (install-double-click-callback w)
  w)

(defmethod window-double-click ((w inspector-window) button position)
  (let ((shape (find-clicked-shape w position)))
    (if shape
        (double-click-inside-shape w shape button position)
      (double-click-no-shape w button position))))

  
(defmethod double-click ((shape shape) button position)
  (send-event shape 'ev-double-click shape button position))

(defmethod ev-double-click ((obj omg-object) sender clicked-obj button position)
  (send-event obj 'ev-double-click clicked-obj button position))
  
(defmethod double-click-inside-shape ((w inspector-window) shape button position)
 (double-click shape button position)
  w)

(defmethod double-click-no-shape ((w inspector-window) button position)
  w)




 
  
  










  
           
  