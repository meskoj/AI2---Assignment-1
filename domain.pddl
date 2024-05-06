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
    (manipulated ?c - component)
    (fixed ?c - component)
    (identified_component ?c - component)
    (identified_component_location ?c - component)
    (mounted_component ?c - component)  

    ; MOTOR INSTALLATION 
    (motor_aligned) ;Rimosso il parametro ?m - motor, controlla che sia sempre corretto

    ; REGULATOR MECHANISM INSTALLATION
    (regulator_mechanism_fixed_to_motor) ;Rimosso il parametro ?r, controlla che sia sempre corretto

    ; MOUNTING BRACKET INSTALLATION
    (mounting_bracket_mounted)
    (fasteners_installed ?mb ) ;Rimosso il parametro ?mb, controlla che sia sempre corretto
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

(:action identify_component_location
    :parameters (?c - component ?w - working_table)
    :precondition (and (at ?c ?w) (at-robby ?w) (not(identified_component_location ?c)))
    :effect (and (identified_component_location ?c))
)
    
(:action manipulate_component ; This means pick up a component and manipulate it
        :parameters (?c - component ?g - gripper)
        :precondition (and (identified_component ?c) (picked_up ?c ?g))
        :effect (and (manipulated ?c))
)

(:action manipulate_fasteners
    :parameters (?c - component ?g - gripper ?w - working_table ?t - tool)
    :precondition (and (at ?c ?w) (at-robby ?w) (at-tool ?t ?w) (mounted_component ?c))
    :effect (and (fixed ?c) )
)


; MOTOR INSTALLATION
(:action align_motor
    :parameters (?g - gripper ?m - motor ?w - working_table ?d - door_frame)
    :precondition (and (at ?m ?w) (at-robby ?w) (at ?d ?w) (manipulated ?m) (picked_up ?m ?g) (identified_component_location ?m) (not(motor_aligned)))
    :effect (and (motor_aligned) (fixed ?m) (free ?g))
)
; OSS: in questo caso si aggiunge il fatto che per essere manipolato il motore deve essere stato identificato

; REGULATOR MECHANISM INSTALLATION

(:action fix_regulator_mechanism
    :parameters (?g - gripper ?r - regulator_mechanism ?w - working_table)
    :precondition (and (at ?r ?w) (at-robby ?w) (manipulated ?r) (identified_component_location ?r) (motor_aligned) (not(regulator_mechanism_fixed_to_motor)))
    :effect (and (regulator_mechanism_fixed_to_motor) (fixed ?r) (not(manipulated ?r)) (free ?g))
)

; MOUNTING BRACKET INSTALLATION
(:action mount_mounting_bracket
    :parameters (?g - gripper ?mb - mounting_bracket ?w - working_table)
    :precondition (and (at ?mb ?w) (at-robby ?w) (identified_component_location ?mb) (manipulated ?mb) (free ?g) (regulator_mechanism_fixed_to_motor))
    :effect (and (mounted_component ?mb))
)

)