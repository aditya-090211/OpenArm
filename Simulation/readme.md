# OpenArm Kinematics Simulation

## Overview

This folder contains the early kinematic simulation environment for OpenArm.

The purpose of this simulation is to:
- understand robotic arm kinematics
- visualize arm movement
- experiment with forward kinematics (FK)
- experiment with inverse kinematics (IK)
- develop trajectory planning systems
- build foundational robotics software knowledge before integrating with physical hardware

This simulation is part of the larger OpenArm project focused on developing affordable, modular, open-source robotic systems.

---

# Current Arm Configuration

Current simulated arm configuration:

| Joint | Description |
|---|---|
| M1 | Shoulder Joint |
| M2 | Elbow Joint |
| M3 | Wrist Joint |

---

# Current Geometry

| Segment | Length |
|---|---|
| M1 → M2 | 75 mm |
| M2 → M3 | 75 mm |
| M3 → End Effector | 75 mm |

Total reach:
```txt
225 mm
```

The current model operates in a planar 2D configuration.

Base rotation is intentionally ignored in the current simulation stage to simplify initial kinematic development.

---

# Goals of This Simulation

The current simulation is intended to help develop:
- robotics intuition
- understanding of arm geometry
- coordinate system understanding
- trajectory planning concepts
- control system foundations
- future integration with physical OpenArm hardware

---

# Current Features

## Forward Kinematics (FK)

The simulator computes end-effector position using joint angles and link lengths.

Forward kinematics calculates:
```txt
Joint Angles → End Effector Position
```

Current outputs:
- elbow position
- wrist position
- end-effector position

---

# Forward Kinematics Equations

The current simulation uses standard planar robotic arm equations:

\[
x = L_1\cos(\theta_1) + L_2\cos(\theta_1+\theta_2) + L_3\cos(\theta_1+\theta_2+\theta_3)
\]

\[
y = L_1\sin(\theta_1) + L_2\sin(\theta_1+\theta_2) + L_3\sin(\theta_1+\theta_2+\theta_3)
\]

Where:
- \(L_n\) = link lengths
- \(\theta_n\) = joint angles

---

# Inverse Kinematics (IK)

The simulator also includes a basic inverse kinematics implementation.

Inverse kinematics calculates:
```txt
Target Position → Joint Angles
```

The IK system attempts to:
- solve reachable target positions
- compute approximate joint angles
- move the arm toward target coordinates

---

# Workspace Visualization

The simulation includes reachable workspace visualization.

This helps visualize:
- reachable regions
- arm limitations
- kinematic boundaries

---

# Trajectory Planning

The current simulation includes basic trajectory interpolation.

This allows:
- smooth arm movement
- continuous motion between poses
- visualization of robotic trajectories

The current implementation uses simple interpolation between joint configurations.

---

# Why This Matters

Kinematics forms the mathematical foundation of robotic motion.

This simulation is intended to build understanding of:
- robotic geometry
- motion planning
- coordinate systems
- robotic control pipelines

before integrating:
- PID control
- encoder feedback
- real actuator control
- reinforcement learning
- physical hardware testing

---

# Future Planned Improvements

Planned future improvements include:
- PID control simulation
- encoder feedback integration
- base rotation support
- 3D visualization
- dynamics simulation
- gravity compensation
- CANBUS communication integration
- real hardware integration
- reinforcement learning experiments
- ROS2 integration

---

# Software Used

Current simulation environment:
- GNU Octave / MATLAB
- basic plotting libraries
- trigonometric kinematic modeling

---

# Educational Purpose

This simulation is intended primarily as:
- a robotics learning environment
- a research and experimentation platform
- a foundation for future OpenArm control systems

The project prioritizes:
- accessibility
- modularity
- open-source learning
- iterative engineering development

---

# Current Development Status

Current status:
```txt
Early kinematic simulation and experimentation phase
```

The simulation and physical OpenArm hardware will continue evolving together throughout development.

---

# Repository Structure

```txt
/Simulation
    openarm_kinematics.m
    README.md
    images/
```

---

# License

This project is part of the OpenArm open-source robotics initiative.
