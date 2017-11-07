(define (problem ship-prob-1-1)
  (:domain spaceship-1-1)
  (:objects
      sship - ship
      cap - capt
      nav - navig
      eng - engineer
      sci - sciencist
      trc - transChief
      med - medic
      rob - robot
      lower1 - lower
      middle1 - middle
      upper1 - upper
      bridge1 - bridge
      cargobay1 - cargobay
      engineroom1 - engineering
      sickbay1 - sickbay
      transporter1 - transporter
      shuttlebay1 - shuttlebay
      sciencelab1 - sciencelab
      mercury venus earth mars saturn jupiter uranus neptune - planet
      light1 light2 light3 - light
      rocksample - light
      plasma1 - plasma
      rover commsstation - heavy
  )

  (:init
      ;planets in an asteroid belt -
      ;any visits to these planets damage the ship
      (in_belt saturn)
      (is_hostile mars)

      ;where da ppl at
      ; planets
      (person_at sci saturn)
      ; rooms on ship
      (person_at cap cargobay1)
      (person_at nav cargobay1)
      (person_at eng bridge1)
      (person_at trc transporter1)
      (person_at med cargobay1)
      (person_at rob sickbay1)

      ;health of people
      (healthy cap)
      (healthy nav)
      (healthy eng)
      (healthy sci)
      (healthy trc)
      (healthy rob)
      (healthy med)

      ;where da equipment at
      (is_heavy rover)
      (is_heavy commsstation)
      (is_plasma plasma1)
      (equip_at light1 transporter1)
      (equip_at light2 cargobay1)
      (equip_at light3 transporter1)
      (equip_at rover cargobay1)
      (equip_at plasma1 earth)
      (equip_at rocksample saturn)

      ;connecting lifts between decks - bidirectional
      ;it is assumed all rooms have a lift and
      ;all lifts can go direct to any deck
      (lift lower1 upper1)
      (lift upper1 lower1)
      (lift middle1 upper1)
      (lift upper1 middle1)
      (lift lower1 middle1)
      (lift middle1 lower1)

      ;connecting doors between rooms - bidirectional
      ;lower
      (door cargobay1 engineroom1)
      (door engineroom1 cargobay1)
      ;middle
      (door sickbay1 sciencelab1)
      (door sciencelab1 sickbay1)
      ;upper
      (door bridge1 transporter1)
      (door transporter1 bridge1)
      (door shuttlebay1 bridge1)
      (door bridge1 shuttlebay1)

      ;assign rooms to decks
      (room_on_deck cargobay1 lower1)
      (room_on_deck engineroom1 lower1)
      (room_on_deck sciencelab1 middle1)
      (room_on_deck sickbay1 middle1)
      (room_on_deck shuttlebay1 upper1)
      (room_on_deck bridge1 upper1)
      (room_on_deck transporter1 upper1)

      ;ship initial conditions
      (ship_at earth)
      (not damaged sship)
      (not damaged transporter1)
      (shuttleCraftAt shuttlebay1)

      ;ship can only travel if travel order given
      (not travel_order)

      (not robot_charged)
    )


    ; transport many light and move ship
    ;(:goal (and (equip_at light2 mars) (equip_at light3 jupiter) (ship_at jupiter)))

    ; transport plasma, damages transporter1
    ;(:goal (and (equip_at plasma1 sciencelab1) (damaged transporter1)))

    ; travel to saturn, transport scientist, damage ship as saturn in asteroid belt
    ; pickup rock sample
    ;(:goal (and (person_at sci transporter1) (ship_at saturn)
        ;        (equip_at rocksample transporter1) (damaged sship)))

    ; hostile planet injures captain
    ;(:goal (and (ship_at mars) (not (healthy cap))))

    ; travel, shuttle heavy to mars
    (:goal (and (equip_at rover mars)))
  )
