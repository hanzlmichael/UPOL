#|
DOKUMENTACE: 

2. zápoètový úkol (INSPECTED a INSPECTOR WINDOW)

Pøed kompilací je tøeba naèíst soubor 05_bounds.lisp, 08.lisp, 08_text_shape

NOVÉ TØÍDY:

TØÍDA INSPECTED-WINDOW

Tøída inspected-window je tøída, která reprezentuje prohlížené okno, ve kterém se pomocí kliku volí objekt jehož informace budou zobrazeny v inspector-window. Je potomkem window.

NOVÉ VLASTNOSTI:

inspected-object - uchovává v sobì informace o prohlíženém objektu, lze nastavovat i èíst

NOVÉ METODY (DOSAŽITELNÉ OD UŽIVATELE)

-žádné

PØEPSANÉ METODY:

window-mouse-down - nastaví inspected-object na shape do kterého bylo kliknuto nebo odešle event delegátovi


TØÍDA MY-TEXT-SHAPE

Tøída my-text-shape je tøída, které reprezentuje jednu kolonku výpisu v inspector-window, dìdí z text-shape a má navíc slot name

NOVÉ VLASTNOSTI: 

name - uchovává jméno, lze nastavovat i èíst

NOVÉ METODY (DOSAŽITELNÉ OD UŽIVATELE)
- žádné

PØEPSANÉ METODY:

-žádné

TØÍDA INSPECTOR-WINDOW

Tøída inspector-window je tøída reprezentující prohlížeè, pøi vytvoøení a pøiøazení inspected window zobrazuje info  o tomto prohlíženém oknì, jinak zobrazuje info o nakliknutém objektu, je v nìm možno i mìnit hodnoty.

NOVÉ VLASTNOSTI:

inspected-window - dle zadání, uchovává v sobì odkaz na prohlížené okno, lze nastavovat i èíst

NOVÉ METODY (DOSAŽITELNÉ OD UŽIVATELE):

set-inspected-window - do slotu pøidá odkaz na okno, které bude prohlíženo

IMPLEMENTACE ZOBRAZENÍ VLASTNÍCH GRAFICKÝCH OBJEKTÙ V INSPEKTORU:

Pokud by uživatel chtìl v prohlížeèi zobrazit informace o svém grafickém objektu (napø. bulls-eye), zmìní solidp objektu na hodnotu true (cokoliv než nil) a poté tento grafický objekt naklikne, informace se automaticky zobrazí v inspectoru a lze je mìnit, v tomto pøípadì je možné mìnit i hodnotu squarep pøímo z prohlížeèe.

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

;;; TØÍDA MY-TEXT-SHAPE

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


;;; FUNKCE PRO VYTVOØENÍ TEXTU

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

;;; TØÍDA INSPECTED-WINDOW

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

;;; TØÍDA INSPECTOR-WINDOW

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
  

;; NOVÉ KLIKÁNÍ

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




 
  
  










  
           
  