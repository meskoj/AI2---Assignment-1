(define (domain assignment)

(:requirements :strips :typing :negative-preconditions)

(:types 
        working_table warehouse - site
        component 
        door_frame motor regulator_mechanism mounting_bracket cable pulley switch wire - component ;types of components
        left right - gripper 
        tool
) 

(:predicates 
    (at-robby ?s - site) ;robot is at site ?s
    (at ?c - component ?s - site) ;component ?c is at site ?s 
    (at-tool ?t - tool ?s - site) ;tool ?t is at site ?s

    (free ?g - gripper)
    (picked_up ?c - component ?g - gripper)
    (picked_tool ?t - tool ?g - gripper)
    (manipulated ?c - component)
    (fixed ?c - component)
    (identified_component ?c - component)
    (identified_mounting_location ?c - component)
    (mounted_component ?c - component)  

    ; MOTOR INSTALLATION 
    (motor_aligned) ;Rimosso il parametro ?m - motor, controlla che sia sempre corretto

    ; REGULATOR MECHANISM INSTALLATION
    (regulator_mechanism_fixed_to_motor) ;Rimosso il parametro ?r, controlla che sia sempre corretto

    ; PULLEY INSTALLATION
    (pulley_tensioned)
    
    ; WIRE INSTALLATION
    (connected_switch_to_wire)
)

(:action robot_move
    :parameters (?from - site ?to - site)
    :precondition (at-robby ?from)
    :effect (and (not(at-robby ?from)) (at-robby ?to))
)

(:action pick_up
    :parameters (?c - component ?g - gripper ?s - site)
    :precondition (and (at-robby ?s) (at ?c ?s) (free ?g) (not(fixed ?c)) (not(picked_up ?c ?g)))
    :effect (and (picked_up ?c ?g) (not(free ?g)))
)

(:action put_down
    :parameters (?c - component ?g - gripper ?s - site)
    :precondition (and (at-robby ?s) (picked_up ?c ?g))
    :effect (and (at ?c ?s) (not(picked_up ?c ?g)) (free ?g))
)

(:action identify_component
    :parameters (?c - component ?w - working_table)
    :precondition (and (at ?c ?w) (at-robby ?w) (not(identified_component ?c)))
    :effect (and (identified_component ?c))
)  

(:action identify_mounting_location
    :parameters (?c - component ?w - working_table)
    :precondition (and (at ?c ?w) (at-robby ?w) (not(identified_mounting_location ?c)))
    :effect (and (identified_mounting_location ?c))
)
    
(:action manipulate_component
        :parameters (?c - component ?g - gripper)
        :precondition (and (identified_component ?c) (picked_up ?c ?g))
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

(:action manipulate_fasteners
    :parameters (?c - component ?g - gripper ?w - working_table ?t - tool)
    :precondition (and (at ?c ?w) (at-robby ?w) (picked_tool ?t ?g) (mounted_component ?c))
    :effect (and (fixed ?c))
)

; MOTOR INSTALLATION
(:action align_motor
    :parameters (?g - gripper ?m - motor ?w - working_table ?d - door_frame)
    :precondition (and (at ?m ?w) (at-robby ?w) (at ?d ?w) (manipulated ?m) (picked_up ?m ?g) (identified_mounting_location ?m) (not(motor_aligned)))
    :effect (and (motor_aligned) (fixed ?m) (free ?g) (not(identified_mounting_location ?m)) (not(identified_component ?m))) ; The component is not identified anymore, since it's position is changed
)
; OSS: in questo caso si aggiunge il fatto che per essere manipolato il motore deve essere stato identificato

; REGULATOR MECHANISM INSTALLATION

(:action fix_regulator_mechanism
    :parameters (?g - gripper ?r - regulator_mechanism ?w - working_table ?m - motor)
    :precondition (and (at ?r ?w) (at-robby ?w) (manipulated ?r) (identified_mounting_location ?r) (identified_component ?m) (picked_up ?r ?g) (motor_aligned) (not(regulator_mechanism_fixed_to_motor)))
    :effect (and (regulator_mechanism_fixed_to_motor) (fixed ?r) (free ?g) (not(identified_component ?r))) ; The component is not identified anymore, since it's position is changed
)

; MOUNTING BRACKET INSTALLATION
(:action mount_mounting_bracket
    :parameters (?g - gripper ?mb - mounting_bracket ?w - working_table)
    :precondition (and (at ?mb ?w) (at-robby ?w) (identified_mounting_location ?mb) (manipulated ?mb) (picked_up ?mb ?g) (not(mounted_component ?mb)) (regulator_mechanism_fixed_to_motor))
    :effect (and (mounted_component ?mb)) ; In questo caso non ho considerato che si è spostato dato che non è necessario per il poi
)
; Remember to fix the mounting bracket before going on

; CABLE AND PULLEYS INSTALLATION
(:action pulley_installation
    :parameters (?g - gripper ?p - pulley ?r - regulator_mechanism ?w - working_table)
    :precondition (and (at ?p ?w) (at-robby ?w) (identified_component ?p) (identified_component ?r) (picked_up ?p ?g) (regulator_mechanism_fixed_to_motor))
    :effect (and (fixed ?p) (not(picked_up ?p ?g)) (free ?g) (not(identified_component ?p)))
)

(:action pulley_tensioning
    :parameters (?g - gripper ?p - pulley ?w - working_table)
    :precondition (and (at-robby ?w) (at ?p ?w) (fixed ?p) (identified_component ?p) (free ?g))
    :effect (and (pulley_tensioned))
)

; SWITCH INSTALLATION
(:action connect_switch_to_wire
    :parameters (?g1 - gripper ?g2 - gripper ?s - switch ?wi - wire ?w - working_table)
    :precondition (and (at ?s ?w) (at ?wi ?w) (at-robby ?w) (identified_component ?s) (identified_component ?wi) (picked_up ?s ?g1) (picked_up ?wi ?g2))
    :effect (and (connected_switch_to_wire))
)


)