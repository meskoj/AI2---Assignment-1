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
        battery - battery
        left right - gripper
        tool - tool
        fastener - fastener
    )

    (:init
        (at-robby working_table)
        (at door_frame working_table) ; Door frame is supposed to be on the working table at the start of the job
        (at-tool tool working_table) ; Tools are supposed to be on the working table at the start of the job
        (at fastener working_table) ; Fasteners are supposed to be on the working table at the start of the job

        ; All the components are in the warehouse at the start of the job
        (at motor warehouse)
        (at regulator_mechanism warehouse)
        (at mounting_bracket warehouse)
        (at cable warehouse)
        (at pulley warehouse)
        (at switch warehouse)
        (at wire warehouse)

        (connected warehouse working_table)

        (free left)
        (free right)
        (different right left)

        (fixed door_frame)
        (at battery working_table)
        (fixed battery) ; Since not explicitly mentioned, I assume that the battery is at the working table and cannot be moved

    )

    (:goal (and
        (connected_motor_to_battery motor battery)) ; This goal includes all the others
    )

)
