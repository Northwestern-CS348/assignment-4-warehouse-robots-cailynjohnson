(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
      :parameters (?li - location ?lf - location ?r - robot)
      :precondition (and (free ?r) (at ?r ?li) (connected ?li ?lf) (no-robot ?lf))
      :effect (and (no-robot ?li) (at ?r ?lf) (not (no-robot ?lf)) (not (at ?r ?li)))
   )
   
   (:action robotMoveWithPallette
      :parameters (?li - location ?lf - location ?r - robot ?p - pallette)
      :precondition (and (at ?r ?li) (at ?p ?li) (connected ?li ?lf) (no-robot ?lf) (no-pallette ?lf))
      :effect (and (has ?r ?p) (not (at ?r ?li)) (at ?r ?lf) (not (at ?p ?li)) (at ?p ?lf) (not (no-robot ?lf)) (no-robot ?li) (not (no-pallette ?lf)) (no-pallette ?li))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (started ?s) (contains ?p ?si) (at ?p ?l) (packing-at ?s ?l) (packing-location ?l) (ships ?s ?o) (orders ?o ?si))
      :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (ships ?s ?o) (packing-at ?s ?l) (packing-location ?l) (not (available ?l)) (not (complete ?s)))
      :effect (and (not (started ?s)) (complete ?s) (not (packing-at ?s ?l)) (available ?l))
   )
   
)
