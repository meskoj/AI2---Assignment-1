(define (domain assignment)

(:requirements:strips :typing :negative-preconditions)

(:types 
        working_table warehouse - site
        component 
        door_frame
        motor regulator_mechanism mounting_bracket cable pulley switch wire - component ;types of components
        gripper 
) 

(:predicates 
    (at-robby ?s - site) ;robot is at site ?s
    (at ?c - component ?s - site) ;component ?c is at site ?s 
    (free ?g - gripper)

    ;MOTOR INSTALLATION 
    (identified_motor_location ?m - motor )
    (motor_manipulated ?m - motor)
    (motor_aligned ?m - motor)
)

(:action move
    :parameters (?from - site ?to - site)
    :precondition (at-robby ?from)
    :effect (and (not (at-robby ?from)) (at-robby ?to))
)

(:action move_component
    :parameters (?from - site ?to - site ?c - component ?g - gripper)
    :precondition (and (at-robby ?from) (at ?c ?from) (free ?g))
    :effect (and (not (at ?c ?from)) (at ?c ?to) (not (at-robby ?from)) (at-robby ?to))
)

; MOTOR INSTALLATION
(:action identify_motor_location
    :parameters (?d - door_frame ?m - motor ?g - gripper ?w - working_table)
    :precondition (and (at ?d ?w) (at ?m ?w) (not (identified_motor_location ?m)))
    :effect (and (identified_motor_location ?m ))
)

(:action manipulate_motor
    :parameters (?g - gripper ?m - motor)
    :precondition (and (identified_motor_location ?m)(free ?g))
    :effect (and (motor_manipulated ?m))
)

(:action align_motor
    :parameters (?g - gripper ?m - motor)
    :precondition (and (motor_manipulated ?m)(free ?g))
    :effect (and (motor_aligned ?m))
)




)