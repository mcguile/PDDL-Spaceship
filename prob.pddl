(define (problem ship-prob-1-1)
  (:domain spaceship-1-1)
  (:objects
      sship - ship
      cap - capt
      nav - navig
      eng - engineer
      sci - sciencist
      trc - transChief
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
      trvl - travelorder
      mercury venus earth mars saturn jupiter uranus neptune - planet
      belt1 - abelt
      light1 - light
      plasma1 - plasma
  )

  (:init
      ;planets in an asteroid belt -
      ;any visits to these planets damage the ship
      (in_belt saturn belt1)

      ;where da ppl at
      ; planets
      (person_on_planet sci saturn)

      ; rooms on ship
      (person_in_room cap cargobay1)
      (person_in_room nav cargobay1)
      (person_in_room eng bridge1)
      (person_in_room trc transporter1)
      (person_in_room rob cargobay1)

      ;where da equipment at
      (equip_in_room light1 transporter1)
      (equip_on_planet plasma1 earth)

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
      (damaged sship)
      (damaged transporter1)

      ;ship can only travel if travel order given
      (not travel_order trvl)

      (not robotCharged rob)
    )

    (:goal (and (equip_on_planet light1 earth)))
  )
