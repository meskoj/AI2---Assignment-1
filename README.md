# Context
In a partially automated industrial context of automobile production, a state-of-the-art humanoid robot named GR-1 is integrated into the assembly line to perform the task of assembling car electric window regulators. GR-1 is equipped with an anthropomorphic and articulated structure, featuring advanced sensors (two cameras, tactile sensors, proprioception sensors, IMUs) and actuators, along with sophisticated computing and control capabilities. GR-1 can move within the environment, recognize objects, pick up objects, put them down, and manipulate them as needed.

# Problem Statement:
You must design and implement a PDDL (Planning Domain Definition Language) domain that models the “car electric windows regulators scenario.” Additionally, you must design at least one PDDL problem that generates a valid plan. Use all the knowledge and capabilities of GR-1 in your design.

## Constraints:
- The robot can carry the objects from the warehouse only one at time
- The robot has two hands and so can manipulate objects with both of them
- The robot must identify and check the mounting status of every component
