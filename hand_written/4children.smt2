(set-logic ALL)
(set-option :produce-models true)
; Datatype for problem representation
(declare-datatypes ((Sport 0)) (( (Basketball) (Baseball) (Soccer) (Volleyball))))
(declare-datatypes ((Child 0)) (( (Brad) (Jenny) (Frank) (Susan))))

; Each child plays a different sport
(declare-fun plays (Child) Sport)
(assert (distinct (plays Brad) (plays Jenny) (plays Frank) (plays Susan)))

; Given information
(assert (or ( = (plays Brad) Basketball) (= (plays Brad) Baseball)))
(assert (= (plays Jenny) Soccer))
(assert (= (plays Frank) Baseball))
(check-sat)
(get-value ((plays Brad) (plays Jenny) (plays Frank) (plays Susan)))