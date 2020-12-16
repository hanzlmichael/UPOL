(in-package :papr4/user)

(defclass unisex-bathroom ()
  ((semaphore-empty :initform (semaphore 1))        ; jestli je mistnost obsazena
   (semaphore-male :initform (semaphore 1))         ; male mutex 
   (semaphore-female :initform (semaphore 1))       ; female mutex
   (semaphore-male-count :initform (semaphore 3))   ; multiplex
   (semaphore-female-count :initform (semaphore 3)) ; multiplex
   (turnstile :initform (semaphore 1))              ; abychom umoznili jeden druh vlakna k zastavení proudeni jineho druhu vlakna
   (fcount :initform 0)                             ; kolik zen je vevnitr
   (mcount :initform 0)))                           ; kolik muzu je vevnitr

;; Z pohledu muze:
;; Pokud jsou v mistnosti muzi, tak nove prichozi projdou skrz
;; turniket a vstoupi. Pokud jsou v mistnosti zeny v dobe kdy
;; prichazi muz, tak se muz zablokuje uvnitr turniketu, coz
;; zabrani vstupu dalsim vlaknum (muzum i zenam) do te doby nez 
;; vsichni ikdo se aktualne nachazi v mistnosti odejdou. 
;; Pak muz ktery ceka na turniketu vstoupi dovnitr a umozni vstup
;; dalsim muzum
;; Obdobne plati z pohledu zeny

(defmethod female ((ub unisex-bathroom))
  (wait-on-semaphore (turnstile ub))                
  (wait-on-semaphore (semaphore-female ub))         
  (incf (slot-value ub 'fcount))
  (if (= fcount 1)
      (wait-on-semaphore semaphore-empty))
  (signal-semaphore (semaphore-female ub))
  (signal-semaphore (turnstile ub))
  (wait-on-semaphore (semaphore-female-count ub))
  (format t "female enters bathroom ~%")
  (signal-semaphore (semaphore-female-count ub))
  (wait-on-semaphore (semaphore-female ub))
  (decf (slot-value ub 'fcount))
  (if (= fcount 0)
      (signal-semaphore semaphore-empty))
  (signal-semaphore (semaphore-female ub)))

(defmethod male ((ub unisex-bathroom))
  (wait-on-semaphore (turnstile ub))
  (wait-on-semaphore (semaphore-male ub))
  (incf (slot-value ub 'mcount))
  (if (= mcount 1)
      (wait-on-semaphore semaphore-empty))
  (signal-semaphore (semaphore-male ub))
  (signal-semaphore (turnstile ub))
  (wait-on-semaphore (semaphore-male-count ub))
  (format t "male enters bathroom ~%")
  (signal-semaphore (semaphore-male-count ub))
  (wait-on-semaphore (semaphore-male ub))
  (decf (slot-value ub 'mcount))
  (if (= mcount 0)
      (signal-semaphore semaphore-empty))
  (signal-semaphore (semaphore-male ub)))

;getters
(defmethod semaphore-empty ((ub unisex-bathroom))
  (slot-value ub 'semaphore-empty))
(defmethod semaphore-male ((ub unisex-bathroom))
  (slot-value ub 'semaphore-male))
(defmethod semaphore-female ((ub unisex-bathroom))
  (slot-value ub 'semaphore-female))
(defmethod semaphore-male-count ((ub unisex-bathroom))
  (slot-value ub 'semaphore-male-count))
(defmethod semaphore-female-count ((ub unisex-bathroom))
  (slot-value ub 'semaphore-female-count))
(defmethod turnstile ((ub unisex-bathroom))
  (slot-value ub 'turnstile))
(defmethod mcount ((ub unisex-bathroom))
  (slot-value ub 'mcount))
(defmethod fcount ((ub unisex-bathroom))
  (slot-value ub 'fcount))




  
  
