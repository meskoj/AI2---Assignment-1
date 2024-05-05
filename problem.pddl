(define 
    (problem problem1) 
    (:domain assignment)
    (:objects 
        warehouse - site
        working_table - site
        door_frame - door_frame
        motor - motor
        regulator_mechanism - regulator_mechanism
        mounting_bracket - mounting_bracket
        cable - cable
        pulley - pulley
        switch - switch
        wire - wire
        gripper - gripper
    )

    (:init
        (free gripper)
        (at-robby working_table)
        (at motor warehouse)
        (at regulator_mechanism warehouse)
        (at mounting_bracket warehouse)
        (at cable warehouse)
        (at pulley warehouse)
        (at switch warehouse)
        (at wire warehouse)

    )

    (:goal (and
        (at motor working_table)
        (at regulator_mechanism working_table)
        (at mounting_bracket working_table) 
        )
    )

)
