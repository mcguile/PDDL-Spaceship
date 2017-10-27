(define (domain spaceship-1-1)
    (:requirements
        :typing
        :strips
        :conditional-effects
        :equality
    )

    (:types
        planet
        ship
        abelt
        deck
        lower middle upper - deck
        room
        bridge engineering sickbay transporter shuttlebay sciencelab cargobay - room
        personnel
        robot capt engineer sciencist navig medic sec trnsChief - personnel
        equipment
        light heavy medical - equipment
        travelorder
    )

    (:predicates
        (in_belt ?p - planet ?ab - abelt)
        (ship_at ?p - planet)
        (person_in_room ?per - personnel ?r - room)
        (person_on_planet ?per - personnel ?pl - planet)
        (equipment_in_room ?e - equipment ?r - room)
        (equipment_at ?e - equipment ?pl - planet)
        (lift ?d1 ?d2 - deck)
        (door ?r1 ?r2 - room)
        (room_on_deck ?r - room ?d - deck)
        (travel_order ?trv - travelorder)
        (damaged ?s - ship)
        (robotCharged ?r - robot)
    )


; NOTE ON ACTIONS - Even though locations of personnel or equipment will be
; implied (i.e. if person is at ship then person is not somewhere else)
; more memory is used to find a plan. Most likely it believes the person
; is at BOTH locations. It may seem like overkill, but we ensure all changed
; states are noted as such e.g. (and (not (in_room x) (in_room y)))



    (:action transport_to_ship
        :parameters (?p - personnel ?rm - transporter ?from - planet)
        :precondition (and (person_on_planet ?p ?from) (not (person_in_room ?p ?rm)))
        :effect (and (person_in_room ?p ?rm) (not (person_on_planet ?p ?from)))
    )

    (:action transport_to_planet
        :parameters (?p - personnel ?rm - transporter ?to - planet)
        :precondition (and (person_in_room ?p ?rm) (not (person_on_planet ?p ?to)))
        :effect (and (not (person_in_room ?p ?rm)) (person_on_planet ?p ?to))
    )

    (:action charge_robot
        :parameters (?rbt - robot ?rm - sciencelab)
        :precondition (and (not (robotCharged ?rbt))
                          (person_in_room ?rbt ?rm))
        :effect (and (robotCharged ?rbt))
    )

    (:action order_travel
        :parameters (?cpt - capt ?r - bridge ?trv - travelorder)
        :precondition (and (person_in_room ?cpt ?r))
        :effect (and (travel_order ?trv))
    )

    (:action use_lift
        :parameters (?p - personnel ?rfrom ?rto - room ?dfrom ?dto - deck)
        :precondition (and (not (person_in_room ?p ?rto))
                           (person_in_room ?p ?rfrom)
                           (lift ?dfrom ?dto)
                           (room_on_deck ?rfrom ?dfrom)
                           (room_on_deck ?rto ?dto)
                           (not ( = ?dfrom ?dto)))
        :effect (and (person_in_room ?p ?rto)
                     (not (person_in_room ?p ?rfrom)))
    )

    (:action use_door
      :parameters (?p - personnel ?rfrom ?rto - room)
      :precondition (and (not (person_in_room ?p ?rto))
                         (person_in_room ?p ?rfrom)
                         (door ?rfrom ?rto))
      :effect (and (person_in_room ?p ?rto)
                   (not (person_in_room ?p ?rfrom)))
    )

    (:action travel
        :parameters (?s - ship ?trv - travelorder ?nav - navig ?r - bridge
                     ?ab - abelt ?from ?to - planet)
        :precondition (and (person_in_room ?nav ?r)
                           (travel_order ?trv)
                           (ship_at ?from)
                           (not (damaged ?s)))
        :effect (and (ship_at ?to)
                     (not (ship_at ?from))
                     (when (in_belt ?to ?ab)(damaged ?s)))
    )

    (:action fix_ship
        :parameters (?s - ship ?p - engineer ?r - engineering)
        :precondition (and (damaged ?s) (person_in_room ?p ?r))
        :effect (and (not (damaged ?s)))
    )
)
