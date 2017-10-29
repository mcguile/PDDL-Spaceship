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
        deck
        lower middle upper - deck
        room
        bridge engineering sickbay transporter shuttlebay sciencelab cargobay - room
        personnel
        capt engineer sciencist navig medic sec transChief robot - personnel
        equipment
        light heavy medical - equipment
        travelorder

        rocksample - light    ;so transporter can take light equipment + samples
        plasma - rocksample
    )

    (:predicates
        (in_belt ?p - planet)
        (ship_at ?p - planet)
        (person_in_room ?per - personnel ?r - room)
        (person_on_planet ?per - personnel ?pl - planet)
        ;equipment includes heavy, light, medical, rock samples and plasma
        ;enables one predicate catch-all
        (equip_in_room ?e - equipment ?r - room)
        (equip_on_planet ?e - equipment ?pl - planet)
        (lift ?d1 ?d2 - deck)
        (door ?r1 ?r2 - room)
        (room_on_deck ?r - room ?d - deck)
        (travel_order)
        (damaged ?s - ship)
        (damaged ?t - transporter)
        (robot_charged)
        (robot_holding ?e - equipment)
    )


; NOTE ON ACTIONS - Even though locations of personnel or equipment will be
; implied (i.e. if person is at ship then person is not somewhere else)
; more memory is used to find a plan. Most likely it believes the person
; is at BOTH locations. It may seem like overkill, but we ensure all changed
; states are noted as such e.g. (and (not (in_room x) (in_room y)))

    ; pickup and drop could have been combined into one action, but
    ;splitting into individual actions allows pickup, move, and drop
    ;all to be displayed in the planner whilst utilizing an existing
    ;travel action
    (:action rob_pickup_equip
        :parameters (?rob - robot ?e - equipment ?rm - room)
        :precondition (and (robot_charged)
                           (person_in_room ?rob ?rm)
                           (equip_in_room ?e ?rm))
        :effect (and (robot_holding ?e)
                     (not (equip_in_room ?e ?rm)))
    )

    ;TODO: Currently a temp variable heavy is compared vs equipment
    ;to determine if it's of type heavy
    ;This does not work ultimately as two different heavy variables will not
    ;be equal to each other
    ;May need separate predicates.
    (:action rob_drop_equip
      :parameters (?h - heavy ?rob - robot ?e - equipment ?rm - room)
      :precondition (and (robot_holding ?e)
                         (person_in_room ?rob ?rm))
      :effect (and (equip_in_room ?e ?rm)
                   (not (robot_holding ?e))
                   (when ( = ?h ?e) (not (robot_charged))))
    )

    (:action transport_equip_to_planet
        :parameters (?trc - transChief ?e - light ?rm - transporter ?to - planet)
        :precondition (and (not (equip_on_planet ?e ?to)) (person_in_room ?trc ?rm)
                           (equip_in_room ?e ?rm) (not (damaged ?rm)))
        :effect (and (not (equip_in_room ?e ?rm))
                     (equip_on_planet ?e ?to))
    )

    ;TODO: Same as heavy temp variable but for plasma.
    (:action transport_equip_to_ship
        :parameters (?pl - p ?trc - transChief ?e - light ?r - robotlasma
                   ?rm - transporter ?from - planet)
        :precondition (and (equip_on_planet ?e ?from) (person_in_room ?trc ?rm)
                         (not (equip_in_room ?e ?rm)) (not (damaged ?rm)))
        :effect (and (equip_in_room ?e ?rm)
                     (not (equip_on_planet ?e ?from))
                     (when ( = ?pl ?e) (damaged ?rm)))
                     ;if the equipment is plamsa, damage the transporter
    )

    (:action transport_to_ship
        :parameters (?trc - transChief ?p - personnel ?rm - transporter ?from - planet)
        :precondition (and (person_on_planet ?p ?from) (person_in_room ?trc ?rm)
                          (not (person_in_room ?p ?rm)) (not (damaged ?rm)))
        :effect (and (person_in_room ?p ?rm) (not (person_on_planet ?p ?from)))
    )

    (:action transport_to_planet
        :parameters (?trc - transChief ?p - personnel ?rm - transporter ?to - planet)
        :precondition (and (person_in_room ?p ?rm) (person_in_room ?trc ?rm)
                           (not (person_on_planet ?p ?to)) (not (damaged ?rm)))
        :effect (and (not (person_in_room ?p ?rm)) (person_on_planet ?p ?to))
    )

    (:action charge_robot
        :parameters (?rbt - robot ?rm - sciencelab)
        :precondition (and (not (robot_charged))
                          (person_in_room ?rbt ?rm))
        :effect (and (robot_charged))
    )

    (:action order_travel
        :parameters (?cpt - capt ?r - bridge)
        :precondition (and (person_in_room ?cpt ?r))
        :effect (and (travel_order))
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
        :parameters (?s - ship ?nav - navig ?rm - bridge ?from ?to - planet)
        :precondition (and (person_in_room ?nav ?rm)
                           (travel_order)
                           (ship_at ?from)
                           (not (damaged ?s)))
        :effect (and (ship_at ?to)
                     (not (ship_at ?from))
                     (when (in_belt ?to)(damaged ?s)))
    )

    (:action fix_ship
        :parameters (?s - ship ?p - engineer ?rm - engineering)
        :precondition (and (damaged ?s) (person_in_room ?p ?rm))
        :effect (and (not (damaged ?s)))
    )

    (:action fix_transporter
        :parameters (?t - transporter ?p - engineer ?rm - transporter)
        :precondition (and (damaged ?t) (person_in_room ?p ?rm))
        :effect (and (not (damaged ?t)))
    )
)
