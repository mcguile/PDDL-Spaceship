(define (domain spaceship-1-1)
    (:requirements
        :typing
        :strips
        :conditional-effects
        :equality
    )

    (:types
        location
        planet abelt ship - location
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
        (adjacent ?p1 ?p2 - planet)
        (in_belt ?p - planet ?ab - abelt)
        (ship_at ?s - ship ?p - planet)
        (person_in_room ?per - personnel ?r - room)
        (person_at ?per - personnel ?l - location)  ;planet or ship
        (lift ?d1 ?d2 - deck)
        (door ?r1 ?r2 - room)
        (room_on_deck ?r - room ?d - deck)
        (travel_order ?trv - travelorder)
        (damaged ?s - ship)
        (robotCharged ?r - robot)
    )

    (:action person_to_ship
        :parameters (?p - personnel ?rm - transporter ?from ?to - location)
        :precondition (and (not (person_at ?p ?to))
                           (person_at ?p ?from) (ship_at ?to ?from))
        :effect (and (person_in_room ?p ?rm) (not (person_at ?p ?from))
                     (person_at ?p ?to))
    )

    (:action person_to_planet
        :parameters (?p - personnel ?rm - transporter ?from ?to - location)
        :precondition (and (person_in_room ?p ?rm) (not (person_at ?p ?to))
                           (person_at ?p ?from) (ship_at ?from ?to))
        :effect (and (not (person_in_room ?p ?rm)) (not (person_at ?p ?from))
                     (person_at ?p ?to))
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
                           (adjacent ?from ?to)
                           (ship_at ?s ?from)
                           (not (damaged ?s)))
        :effect (and (ship_at ?s ?to)
                     (not (ship_at ?s ?from))
                     (when (in_belt ?to ?ab)(damaged ?s)))
    )

    (:action fix_ship
        :parameters (?s - ship ?p - engineer ?r - engineering)
        :precondition (and (damaged ?s) (person_in_room ?p ?r))
        :effect (and (not (damaged ?s)))
    )
)
