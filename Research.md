# OpenArm Research Notes

This document contains ongoing research, engineering notes, design ideas, tradeoff analysis, and technical exploration related to the development of OpenArm.

The purpose of this file is to document:
- engineering decisions
- failed ideas
- architecture exploration
- actuator research
- control systems
- manufacturability analysis
- educational accessibility considerations

---

# Current Research Areas

## Actuator Systems

Currently exploring multiple actuator architectures including:
- stepper motors
- pancake NEMA17 motors
- brushless gimbal motors
- integrated CAN-based actuator systems

Primary focus areas:
- affordability
- smoothness
- modularity
- torque density
- precision
- scalability
- ease of assembly

---

# CAN-Based Distributed Architecture

One of the primary architectures currently being explored is a distributed CAN-based actuator system using:
- CANBUS-Stepper boards
- ESP32-based control
- daisy-chained communication
- modular actuator nodes

Potential advantages:
- simplified wiring
- scalability
- cleaner assembly
- modularity
- easier debugging and replacement
- more professional robotics architecture

Current concerns:
- cost per actuator
- software complexity
- encoder integration
- synchronization
- power distribution

---

# Stepper Motor Research

Current prototype direction:
- Pancake NEMA17 motors
- Belt reduction systems
- Lightweight PETG structures
- Aluminum reinforcement

Current goals:
- reduce joint weight
- improve smoothness
- reduce backlash
- maintain affordability

---

# Transmission Research

Currently researching:
- GT2 belt reduction
- HTD belt systems
- planetary gearboxes
- harmonic drives
- cycloidal reducers

Current preferred solution:
- belt reduction

Reasons:
- lightweight
- inexpensive
- easier to manufacture
- lower complexity
- easier maintenance

---

# Encoder Research

Encoder integration is currently being evaluated.

Potential encoder options:
- AS5600
- AS5048A

Current development strategy:
- open-loop initially
- closed-loop later

---

# Control Systems

Current research topics:
- PID control
- inverse kinematics
- motion profiling
- trajectory planning
- reinforcement learning
- robotic manipulation systems

Long-term research interest:
Comparing reinforcement learning and traditional PID tuning methods for low-cost robotic arm systems.

---

# Design Philosophy

OpenArm aims to prioritize:
- accessibility
- affordability
- modularity
- repairability
- educational value
- open-source collaboration

The project is intended to evolve through continuous iteration, testing, documentation, and experimentation.

---

# Current Priorities

1. Functional actuator testing
2. Lightweight joint design
3. Reliable motion
4. Manufacturability
5. Cost reduction
6. Modularity
7. Simplified assembly
8. Documentation

---

# Future Research Goals

- Closed-loop control
- Advanced actuator systems
- CAN optimization
- Modular electronics
- ROS integration
- Reinforcement learning experimentation
- Educational kit development
- Open-source robotics ecosystem
