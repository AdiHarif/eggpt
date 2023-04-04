;The suitcase fits inside the box.
;The chocolate fits inside the box.
;The container is bigger than the box of chocolates.
;The container is bigger than the suitcase.
;The box is bigger than the box of chocolates.
;The container is bigger than the chocolate.
;The chocolate fits inside the container.
;The chocolate fits inside the suitcase.
;The chocolate fits inside the chest.
;The suitcase fits inside the container.
;Does the box fit in the chocolate?	no	8 1
;Is the chocolate bigger than the box?	no	8 1
;Does the box fit in the chocolate?	no	8 1
;Does the box fit in the chocolate?	no	8 1
;Is the chocolate bigger than the box?	no	8 1

(set-logic ALL)
(set-option :produce-models true)
; Datatype for problem representation
(declare-datatypes ((Object 0)) (( (Chocolate) (Box) (Suitcase) (Container) (Chest) (BoxChocolates))))

; Object either bigger or not
(declare-fun bigger (Object Object) Bool)
(assert (forall ((o1 Object)) (not (bigger o1 o1))))

; Given information
(assert (bigger Box Suitcase))
(assert (bigger Box Chocolate))
(assert (bigger Container BoxChocolates))
(assert (bigger Container Suitcase))
(assert (bigger Box BoxChocolates))
(assert (bigger Container Chocolate))
(assert (bigger Container Chocolate))
(assert (bigger Suitcase Chocolate))
(assert (bigger Chest Chocolate))
(assert (bigger Container Suitcase))

; bigger should be transitive
(assert (forall ((o1 Object) (o2 Object) (o3 Object))
  (=> (and (bigger o1 o2) (bigger o2 o3)) (bigger o1 o3))))

; bigger should be asymmetric
(assert (forall ((o1 Object) (o2 Object))
  (=> (bigger o1 o2) (not (bigger o2 o1)))))

(check-sat)
(get-value ((bigger Chocolate Box) (bigger Chocolate Box)))