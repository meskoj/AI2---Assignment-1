(define (domain assignment)

(:requirements :strips :typing :conditional-effects :negative-preconditions :disjunctive-preconditions)

(:types 
        working_table warehouse - site
        door_frame motor regulator_mechanism mounting_bracket cable pulley switch wire battery fastener - component ;types of components
        gripper 
        tool
) 

(:predicates 
    (at-robby ?s - site) ;robot is at site ?s
    (at ?c - component ?s - site) ;component ?c is at site ?s 
    (at-tool ?t - tool ?s - site) ;tool ?t is at site ?s

    (connected ?s1 - site ?s2 - site) ;site ?s1 is connected to site ?s2
    (free ?g - gripper)
    (different ?g1 - gripper ?g2 - gripper)
    (picked_up ?c - component ?g - gripper)
    (picked_tool ?t - tool ?g - gripper)
    (manipulated ?c - component)
    (fixed ?c - component)
    (identified_component ?c - component )
    (identified_mounting_location ?c - component ?d - door_frame)
    (mounted_component ?c - component)  

    ; MOTOR INSTALLATION 
    (motor_aligned ?m - motor) 

    ; REGULATOR MECHANISM INSTALLATION
    (regulator_mechanism_fixed_to_motor ?r - regulator_mechanism) 

    ; PULLEY INSTALLATION
    (cable_installed ?c - cable)
    (cable_tensioned ?c - cable)
    
    ; WIRE INSTALLATION
    (connected_switch_to_wire ?s - switch ?wi - wire)
    (connected_wire_to_motor ?wi - wire ?m - motor) 
    (connected_motor_to_battery ?m - motor ?b - battery)
)

(:action robot_move
    :parameters (?from - site ?to - site ?c - component ?g1 - gripper ?g2 - gripper)
    :precondition (and (at-robby ?from) (different ?g1 ?g2) (or (connected ?from ?to) (connected ?to ?from)) (or (free ?g1) (free ?g2))) ; This force the robot to move only one component at time from the warehouse
    :effect(and (not (at-robby ?from)) (at-robby ?to)
                (forall (?c - component) 
                    (when (and (at ?c ?from) (identified_component ?c))
                        (not (identified_component ?c)))) ; When the robot moves from a site, the identified components are not identified anymore
                (when (or (picked_up ?c ?g1) (picked_up ?c ?g2))
                    (and (not (at ?c ?from)) (at ?c ?to) (identified_component ?c)))) ; When the robot moves the component, the component moves with it and it is identified
)

(:action pick_up
    :parameters (?c - component ?g - gripper ?s - site)
    :precondition (and (at-robby ?s) (at ?c ?s) (identified_component ?c) (free ?g) (not(fixed ?c)) (not(picked_up ?c ?g))) ; Before pick_up I need to identify the component and it should not be fixed
    :effect (and (picked_up ?c ?g) (not(free ?g)))
)

(:action put_down
    :parameters (?c - component ?g - gripper ?s - site)
    :precondition (and (at-robby ?s) (picked_up ?c ?g))
    :effect (and (at ?c ?s) (not(picked_up ?c ?g)) (free ?g) (not(identified_component ?c)) (not(manipulated ?c)))
)

(:action identify_component
    :parameters (?c - component ?s - site)
    :precondition (and (at ?c ?s) (at-robby ?s) (not(identified_component ?c)))
    :effect (and (identified_component ?c))
)  

(:action identify_mounting_location
    :parameters (?c - component ?g - gripper ?d - door_frame ?w - working_table)
    :precondition (and (picked_up ?c ?g) (at-robby ?w) (at ?d ?w) (not(identified_mounting_location ?c ?d)))
    :effect (and (identified_mounting_location ?c ?d))
)
    
(:action manipulate_component
        :parameters (?c - component ?g - gripper ?d - door_frame)
        :precondition (and (identified_component ?c) (identified_mounting_location ?c ?d) (picked_up ?c ?g))
        :effect (and (manipulated ?c))
)

(:action pick_up_tool
    :parameters (?g - gripper ?t - tool ?s - site)
    :precondition (and (at-tool ?t ?s) (at-robby ?s) (free ?g))
    :effect (and (picked_tool ?t ?g) (not(free ?g)))
)

(:action put_down_tool
    :parameters (?g - gripper ?t - tool ?s - site)
    :precondition (and (at-robby ?s) (picked_tool ?t ?g))
    :effect (and (at-tool ?t ?s) (free ?g) (not(picked_tool ?t ?g)))
)

;(:action manipulate_fasteners
;    :parameters (?c - component ?g1 - gripper ?g2 - gripper ?f - fastener ?w - working_table ?t - tool)
;    :precondition (and (at ?c ?w) (at-robby ?w) (different ?g1 ?g2) (picked_tool ?t ?g1) (picked_up ?f ?g2) (mounted_component ?c))
;    :effect (and (manipulated ?))
;)

; MOTOR INSTALLATION
(:action align_motor
    :parameters (?g - gripper ?m - motor ?w - working_table ?d - door_frame)
    :precondition (and (at ?m ?w) (at-robby ?w) (at ?d ?w) 
                       (manipulated ?m) (picked_up ?m ?g) (identified_mounting_location ?m ?d) (not(motor_aligned ?m)))
    :effect (and (motor_aligned ?m) (fixed ?m) (free ?g) (not(picked_up ?m ?g)) (not(identified_component ?m))) ; The component is not identified anymore, since it's position is changed
)

; REGULATOR MECHANISM INSTALLATION

(:action fix_regulator_mechanism
    :parameters (?g - gripper ?r - regulator_mechanism ?d - door_frame ?w - working_table ?m - motor)
    :precondition (and (at ?r ?w) (at-robby ?w) 
                       (manipulated ?r) (identified_mounting_location ?r ?d) (identified_component ?m) (picked_up ?r ?g) (not(regulator_mechanism_fixed_to_motor ?r))
                       (motor_aligned ?m))
    :effect (and (regulator_mechanism_fixed_to_motor ?r) (fixed ?r) (free ?g) (not(picked_up ?r ?g)) (not(identified_component ?r)))
)

; MOUNTING BRACKET INSTALLATION
(:action mount_mounting_bracket
    :parameters (?g - gripper ?mb - mounting_bracket ?m - motor ?d - door_frame ?r - regulator_mechanism ?w - working_table)
    :precondition (and (at ?mb ?w) (at-robby ?w) 
                       (identified_mounting_location ?mb ?d) (manipulated ?mb) (picked_up ?mb ?g) (not(mounted_component ?mb)) 
                       (motor_aligned ?m) (regulator_mechanism_fixed_to_motor ?r))
    :effect (and (mounted_component ?mb) (not(picked_up ?mb ?g)) (free ?g) (not(identified_component ?mb))) 
)

(:action fix_mounting_bracket
    :parameters (?g1 - gripper ?g2 - gripper ?mb - mounting_bracket ?t - tool ?f - fastener ?m - motor ?r - regulator_mechanism ?w - working_table)
    :precondition (and (at ?mb ?w) (at-robby ?w)
                  (identified_component ?mb) (mounted_component ?mb) (picked_tool ?t ?g1) (picked_up ?f ?g2) (different ?g1 ?g2) (manipulated ?f)
                  (motor_aligned ?m) (regulator_mechanism_fixed_to_motor ?r))
    :effect (and (fixed ?mb) (free ?g2)) ; Once the mounting bracket is fixed, the gripper holding the fastener is free
)


; CABLE AND PULLEYS INSTALLATION
(:action pulley_installation
    :parameters (?g - gripper ?p - pulley ?m - motor ?r - regulator_mechanism ?mb - mounting_bracket ?w - working_table)
    :precondition (and (at ?p ?w) (at-robby ?w)
                       (identified_component ?p) (identified_component ?r ) (picked_up ?p ?g) (not(fixed ?p))
                       (motor_aligned ?m) (regulator_mechanism_fixed_to_motor ?r) (fixed ?mb))
    :effect (and (fixed ?p) (not(picked_up ?p ?g)) (free ?g) (not(identified_component ?p)))
)

(:action cable_installation
    :parameters (?g - gripper ?c - cable ?p - pulley ?m - motor ?r - regulator_mechanism ?mb - mounting_bracket ?w - working_table)
    :precondition (and (at ?c ?w) (at-robby ?w)
                  (identified_component ?c) (identified_component ?p) (picked_up ?c ?g) (not(cable_installed ?c))
                  (fixed ?p) (motor_aligned ?m) (regulator_mechanism_fixed_to_motor ?r) (fixed ?mb))
    :effect (and (cable_installed ?c) (not(picked_up ?c ?g)) (free ?g))
)

(:action cable_tensioning
    :parameters (?g - gripper ?c - cable ?p - pulley ?m - motor ?r - regulator_mechanism ?mb - mounting_bracket ?w - working_table)
    :precondition (and (at-robby ?w) (at ?c ?w) 
                       (cable_installed ?c) (free ?g) (not(cable_tensioned ?c))
                       (fixed ?p) (motor_aligned ?m) (regulator_mechanism_fixed_to_motor ?r) (fixed ?mb))
    :effect (and (cable_tensioned ?c))
)

; WIRES INSTALLATION
(:action connect_switch_to_wire
    :parameters (?g1 - gripper ?g2 - gripper ?s - switch ?wi - wire ?m - motor ?r - regulator_mechanism ?mb - mounting_bracket ?c - cable ?w - working_table)
    :precondition (and (at ?s ?w) (at ?wi ?w) (at-robby ?w) (identified_component ?s) (identified_component ?wi) 
                  (picked_up ?s ?g1) (picked_up ?wi ?g2) (manipulated ?s) (manipulated ?wi) (not(connected_switch_to_wire ?s ?wi))
                  (motor_aligned ?m) (regulator_mechanism_fixed_to_motor ?r) (fixed ?mb) (cable_tensioned ?c))
    :effect (and (connected_switch_to_wire ?s ?wi))
)

(:action connect_wire_to_motor
    :parameters (?g - gripper  ?s - switch ?m - motor ?wi - wire ?w - working_table ?r - regulator_mechanism ?mb - mounting_bracket ?c - cable)
    :precondition (and (at ?wi ?w) (at-robby ?w) 
                       (identified_component ?wi) (identified_component ?m) (picked_up ?wi ?g) (not(connected_wire_to_motor ?wi ?m))
                       (connected_switch_to_wire ?s ?wi) (motor_aligned ?m) (regulator_mechanism_fixed_to_motor ?r) (fixed ?mb) (cable_tensioned ?c))
    :effect (and (connected_wire_to_motor ?wi ?m))
)

(:action connect_motor_to_battery
    :parameters (?g - gripper ?b - battery ?m - motor ?s - switch ?wi - wire ?w - working_table ?r - regulator_mechanism ?mb - mounting_bracket ?c - cable)
    :precondition (and (at ?m ?w) (at ?b ?w) (at-robby ?w)
                       (identified_component ?m) (identified_component ?b) (picked_up ?wi ?g) (not(connected_motor_to_battery ?m ?b))
                       (connected_wire_to_motor ?wi ?m)(connected_switch_to_wire ?s ?wi) (motor_aligned ?m) (regulator_mechanism_fixed_to_motor ?r) (fixed ?mb) (cable_tensioned ?c))
    :effect (and (connected_motor_to_battery ?m ?b))
)


)