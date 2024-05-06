(define 
    (problem problem1) 
    (:domain assignment)
    (:objects 
        warehouse - warehouse
        working_table - working_table
        door_frame - door_frame
        motor - motor
        regulator_mechanism - regulator_mechanism
        mounting_bracket - mounting_bracket
        cable - cable
        pulley - pulley
        switch - switch
        wire - wire
        left right - gripper
        tool - tool
    )

    (:init
        (at-robby working_table)
        (at door_frame working_table)
        (at-tool tool working_table)
        (at motor warehouse)
        (at regulator_mechanism warehouse)
        (at mounting_bracket warehouse)
        (at cable warehouse)
        (at pulley warehouse)
        (at switch warehouse)
        (at wire warehouse)
        (free left)
        (free right)
        (fixed door_frame)

    )

    (:goal (and
        (fixed mounting_bracket)
    ))

)
