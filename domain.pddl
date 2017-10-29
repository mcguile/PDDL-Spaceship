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
        (person_at ?per - personnel ?r - room)
        (person_at ?per - personnel ?pl - planet)
        ;equipment includes heavy, light, medical, rock samples and plasma
        ;enables one predicate catch-all
        (equip_at ?e - equipment ?r - room)
        (equip_at ?e - equipment ?pl - planet)
        (is_heavy ?e)
        (is_plasma ?e)
        (lift ?d1 ?d2 - deck)
        (door ?r1 ?r2 - room)
        (room_on_deck ?r - room ?d - deck)
        (travel_order)
        (damaged ?s - ship)
        (damaged ?t - transporter)
        (robot_charged)
        (robot_holding ?e - equipment)
        (shuttleCraftAt ?rm - shuttlebay)
        (shuttleCraftAt ?p - planet)
    )


; NOTE ON ACTIONS - Even though locations of personnel or equipment will be
; implied (i.e. if person is at ship then person is not somewhere else)
; more memory is used to find a plan. Most likely it believes the person
; is at BOTH locations. It may seem like overkill, but we ensure all changed
; states are noted as such e.g. (and (not (in_room x) (in_room y)))

    (:action shuttlecraft_to_planet
        :parameters(?rm - shuttlebay ?p - personnel
                    ?pl - planet ?e - equipment)
        :precondition (and (person_at ?p ?rm)
                           (equip_at ?e ?rm)
                           (shuttleCraftAt ?rm)
                           (not (shuttleCraftAt ?pl)))
        :effect (and (not (person_at ?p ?rm))
                     (not (shuttleCraftAt ?rm))
                     (not (equip_at ?e ?rm))
                     (equip_at ?e ?pl)
                     (person_at ?p ?pl)
                     (shuttleCraftAt ?pl))
   )

   (:action shuttlecraft_to_ship
       :parameters(?rm - shuttlebay ?p - personnel ?s - ship
                   ?pl - planet ?e - equipment)
       :precondition(and (person_at ?p ?pl)
                         (equip_at ?e ?pl)
                         (shuttleCraftAt ?pl))
       :effect (and (not (person_at ?p ?pl))
                    (not (shuttleCraftAt ?pl))
                    (not (equip_at ?e ?pl))
                    (equip_at ?e ?rm)
                    (person_at ?p ?rm)
                    (shuttleCraftAt ?s))
  )

    ;pickup and drop could have been combined into one action, but
    ;splitting into individual actions allows pickup, move, and drop
    ;all to be displayed in the planner whilst utilizing an existing
    ;travel action
    (:action rob_pickup_equip
        :parameters (?rob - robot ?e - equipment ?rm - room)
        :precondition (and (robot_charged)
                           (person_at ?rob ?rm)
                           (equip_at ?e ?rm))
        :effect (and (robot_holding ?e)
                     (not (equip_at ?e ?rm)))
    )

    (:action rob_drop_equip
      :parameters (?rob - robot ?e - equipment ?rm - room)
      :precondition (and (robot_holding ?e)
                         (person_at ?rob ?rm))
      :effect (and (equip_at ?e ?rm)
                   (not (robot_holding ?e))
                   (when (is_heavy ?e) (not (robot_charged))))
    )

    (:action transport_equip_to_planet
        :parameters (?trc - transChief ?e - light ?rm - transporter ?to - planet)
        :precondition (and (not (equip_at ?e ?to)) (person_at ?trc ?rm)
                           (equip_at ?e ?rm) (not (damaged ?rm)))
        :effect (and (not (equip_at ?e ?rm))
                     (equip_at ?e ?to))
    )

    (:action transport_equip_to_ship
        :parameters (?trc - transChief ?e - light ?r - robotlasma
                   ?rm - transporter ?from - planet)
        :precondition (and (equip_at ?e ?from) (person_at ?trc ?rm)
                         (not (equip_at ?e ?rm)) (not (damaged ?rm)))
        :effect (and (equip_at ?e ?rm)
                     (not (equip_at ?e ?from))
                     (when (is_plasma ?e) (damaged ?rm)))
                     ;if the equipment is plamsa, damage the transporter
    )

    (:action transport_to_ship
        :parameters (?trc - transChief ?p - personnel ?rm - transporter ?from - planet)
        :precondition (and (person_at ?p ?from) (person_at ?trc ?rm)
                          (not (person_at ?p ?rm)) (not (damaged ?rm)))
        :effect (and (person_at ?p ?rm) (not (person_at ?p ?from)))
    )

    (:action transport_to_planet
        :parameters (?trc - transChief ?p - personnel ?rm - transporter ?to - planet)
        :precondition (and (person_at ?p ?rm) (person_at ?trc ?rm)
                           (not (person_at ?p ?to)) (not (damaged ?rm)))
        :effect (and (not (person_at ?p ?rm)) (person_at ?p ?to))
    )

    (:action charge_robot
        :parameters (?rbt - robot ?rm - sciencelab)
        :precondition (and (not (robot_charged))
                          (person_at ?rbt ?rm))
        :effect (and (robot_charged))
    )

    (:action order_travel
        :parameters (?cpt - capt ?r - bridge)
        :precondition (and (person_at ?cpt ?r))
        :effect (and (travel_order))
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
        :parameters (?s - ship ?nav - navig ?rm - bridge ?from ?to - planet)
        :precondition (and (person_at ?nav ?rm)
                           (travel_order)
                           (ship_at ?from)
                           (not (damaged ?s)))
        :effect (and (ship_at ?to)
                     (not (ship_at ?from))
                     (when (in_belt ?to)(damaged ?s)))
    )

    (:action fix_ship
        :parameters (?s - ship ?p - engineer ?rm - engineering)
        :precondition (and (damaged ?s) (person_at ?p ?rm))
        :effect (and (not (damaged ?s)))
    )

    (:action fix_transporter
        :parameters (?p - engineer ?rm - transporter)
        :precondition (and (damaged ?rm) (person_at ?p ?rm))
        :effect (and (not (damaged ?rm)))
    )
)
