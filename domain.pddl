(define (domain spaceship-1-1)
    (:requirements
        :typing
        :strips
        :conditional-effects
        :equality
    )

    (:types
        location
        planet abelt - location
        ship
        deck
        lower middle upper - deck
        room
        bridge engineering sickbay transporter shuttlebay sciencelab cargobay - room
        personnel
        capt engineer sciencist navig medic sec trnsChief - personnel
        robot
        equipment
        light heavy medical - equipment
        travelorder
    )

    (:predicates
        (adjacent ?p1 ?p2 - planet)
        (in_belt ?p - planet ?ab - abelt)
        (ship_at ?s - ship ?p - planet)
        (person_at ?per - personnel ?r - room)
        (lift ?d1 ?d2 - deck)
        (door ?r1 ?r2 - room)
        (room_on_deck ?r - room ?d - deck)
        (travel_order ?trv - travelorder)
        (damaged ?s - ship)
    )

    (:action order_travel
        :parameters (?cpt - capt ?r - bridge ?trv - travelorder)
        :precondition (and (person_at ?cpt ?r))
        :effect (and (travel_order ?trv))
    )

    (:action use_lift
        :parameters (?p - personnel ?rfrom ?rto - room ?dfrom ?dto - deck)
        :precondition (and (not (person_at ?p ?rto))
                           (person_at ?p ?rfrom)
                           (lift ?dfrom ?dto)
                           (room_on_deck ?rfrom ?dfrom)
                           (room_on_deck ?rto ?dto)
                           (not ( = ?dfrom ?dto)))
        :effect (and (person_at ?p ?rto)
                     (not (person_at ?p ?rfrom)))
    )

    (:action use_door
      :parameters (?p - personnel ?rfrom ?rto - room)
      :precondition (and (not (person_at ?p ?rto))
                         (person_at ?p ?rfrom)
                         (door ?rfrom ?rto))
      :effect (and (person_at ?p ?rto)
                   (not (person_at ?p ?rfrom)))
    )

    (:action travel
        :parameters (?s - ship ?trv - travelorder ?nav - navig ?r - bridge
                     ?ab - abelt ?from ?to - planet)
        :precondition (and (person_at ?nav ?r)
                           (travel_order ?trv)
                           (adjacent ?from ?to)
                           (ship_at ?s ?from)
                           (not (damaged ?s)))
        :effect (and (ship_at ?s ?to)
                     (not (ship_at ?s ?from))
                     (when (in_belt ?to ?ab)(damaged ?s)))
    )

    (:action fix_ship
        :parameters (?s - ship ?p - engineer ?r - engineering)
        :precondition (and (damaged ?s) (person_at ?p ?r))
        :effect (and (not (damaged ?s)))
    )
)
