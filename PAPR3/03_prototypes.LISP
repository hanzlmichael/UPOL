;10.1.
[true add "OR" :value true]
[false add "OR" :value {(arg1) arg1}]
[true add "NOT" :value false]
[false add "NOT" :value true]

;10.2.
[nihil add "IS-NIHIL" :value true]
[object add "IS-NIHIL" :value false]

;10.3.

[object add "PAIR" :value  [object clone]]
[pair set-name "PAIR"]
[pair add "CAR" :value nihil]
[pair add "CDR" :value nihil]
[object add "CONS" :value {(new) [[] set-new [pair clone]]
                         [new set-car self]
                         [new set-cdr arg1]
                         new}]
[object add "NULL" :value  [pair clone]]
[null set-name "NULL"]

;10.5. 

[null add "LENGTH" :value zero]
[pair add "LENGTH" :value {() [[[self cdr] length] + one]}]

;10.6. 

[pair add "APPEND" :value {() [[self is null] if-true  {() arg1} :else {() [[self car] cons [[self cdr] append arg1 ]]}]}]
[pair add "REVERSE" :value {() [[self is null] if-true {() null} :else {() [[[self cdr] reverse] cons [self car]]}]}]

;10.7. 

[pair add "BROADCAST" :value {(self arg1m intern) [[] set-intern {(arg1) [[arg1 is null] if-true {() self}
                                                                      :else {() [[] arg1m [arg1 car]]
                                                                             [[] intern [arg1 cdr]]}]}]
                              [[] intern self]}]

;10.10.

[object add "ERROR" :value (lambda (self arg1 &key)
                             (declare (ignore arg1))
                             (error self))]
