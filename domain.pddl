(define (domain assignment)

(:requirements:strips :typing :negative-preconditions)

(:types 
        working_table warehouse - site
        component 
        ;door_frame
        motor regulator_mechanism mounting_bracket cable pulley switch wire - component ;types of components
        gripper 
) 

(:predicates 
    (at-robby ?s - site) ;robot is at site ?s
    ;(at-door_frame ?d - door_frame ?s - site) door frame supposed to be at working table, not necessary to check the position
    (at ?c - component ?s - site) ;component ?c is at site ?s 
    (free ?g - gripper)

    ;MOTOR INSTALLATION 
    (identified_motor_location ?m - motor )
    (motor_manipulated ?m - motor)
    (motor_aligned ) ;Rimosso il parametro ?m - motor, controlla che sia sempre corretto

    ;REGULATOR MECHANISM ATTACHMENT
    (identified_regulator_mechanism_location ?r - regulator_mechanism)
    (identified_regulator_mechanism ?r - regulator_mechanism)
    (regulator_mechanism_manipulated ?r - regulator_mechanism)
    (regulator_mechanism_fixed_to_motor ?r - regulator_mechanism)
)

(:action robot_move
    :parameters (?from - site ?to - site)
    :precondition (at-robby ?from)
    :effect (and (not (at-robby ?from)) (at-robby ?to))
)

(:action move_component
    :parameters (?c - component  ?from - site ?to - site ?g - gripper)
    :precondition (and (at-robby ?from) (at ?c ?from) (free ?g))
    :effect (and (not (at ?c ?from)) (at ?c ?to) (not (at-robby ?from)) (at-robby ?to))
)

; MOTOR INSTALLATION
(:action identify_motor_location
    :parameters (?m - motor ?g - gripper ?w - working_table)
    :precondition (and (at ?m ?w) (not (identified_motor_location ?m))) ; (at ?d ?w)
    :effect (and (identified_motor_location ?m ))
)

(:action manipulate_motor
    :parameters (?g - gripper ?m - motor ?w - working_table)
    :precondition (and (at ?m ?w)(identified_motor_location ?m)(free ?g))
    :effect (and (motor_manipulated ?m))
)

(:action align_motor
    :parameters (?g - gripper ?m - motor ?w - working_table)
    :precondition (and (at ?m ?w) (motor_manipulated ?m)(free ?g))
    :effect (and (motor_aligned ))
)

; REGULATOR MECHANISM ATTACHMENT
(:action identify_regulator_mechanism_location
    :parameters ( ?r - regulator_mechanism ?w - working_table)
    :precondition (and (at ?r ?w) (motor_aligned) (not (identified_regulator_mechanism_location ?r)))
    :effect (and (identified_regulator_mechanism_location ?r))
)

(:action identify_regulator_mechanism
    :parameters (?r - regulator_mechanism ?w - working_table)
    :precondition (and (at ?r ?w) (not (identified_regulator_mechanism ?r))(identified_regulator_mechanism_location ?r))
    :effect (and (identified_regulator_mechanism ?r) )
)

(:action manipulate_regulator_mechanism
    :parameters (?g - gripper ?r - regulator_mechanism ?w - working_table)
    :precondition (and (at ?r ?w)(identified_regulator_mechanism_location ?r)(identified_regulator_mechanism ?r)(free ?g))
    :effect (and (regulator_mechanism_manipulated ?r))
)

(:action fix_regulator_mechanism
    :parameters (?g - gripper ?r - regulator_mechanism ?w - working_table)
    :precondition (and (at ?r ?w)(regulator_mechanism_manipulated ?r)(free ?g))
    :effect (and (regulator_mechanism_fixed_to_motor ?r))
)

;;





)