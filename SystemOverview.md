# OpenArm System Overview

## Introduction

OpenArm is an open-source robotic arm platform currently focused on developing lightweight, modular, and accessible robotic systems for education, experimentation, and research.

The project aims to reduce the complexity and cost of robotic arm systems while maintaining a strong focus on:
- modularity
- manufacturability
- repairability
- scalability
- educational accessibility

The long-term goal of OpenArm is to create a robotics platform that can eventually be distributed to schools and students with limited access to advanced robotics education.

---

# Current System Architecture

The current OpenArm prototype is designed as a 4-DOF robotic arm using distributed actuator control and lightweight structural components.

## Degrees of Freedom

Current planned configuration:
1. Base Rotation
2. Shoulder Joint
3. Elbow Joint
4. Wrist Joint

---

# Mechanical Architecture

## Structure

The arm currently uses a hybrid structure consisting of:
- 3D printed PETG components
- aluminum reinforcement plates and structural members
- belt-driven transmission systems

The current design philosophy prioritizes:
- low weight
- simplified assembly
- reduced part count
- modular replacement
- easy manufacturability

---

# Actuator Architecture

The current actuator system uses:
- NEMA17 stepper motors
- pancake NEMA17 motors for lightweight joints
- distributed CANBUS-Stepper controllers
- HTD belt reduction systems

## Current Joint Configuration

| Joint | Motor Type |
|---|---|
| Base | Standard NEMA17 |
| Shoulder | Standard NEMA17 |
| Elbow | Pancake NEMA17 |
| Wrist | Pancake NEMA17 |

---

# Electronics Architecture

The electronics system is currently based around a distributed actuator architecture.

Each actuator contains:
- local motor control
- CAN communication
- encoder support
- integrated actuator electronics

A Raspberry Pi is planned as the high-level control computer for:
- trajectory control
- inverse kinematics
- motion coordination
- future robotics software integration

---

# Communication System

The current communication architecture is based on:
- CAN bus communication
- daisy-chained actuator nodes
- distributed control

This architecture was selected to improve:
- scalability
- wiring simplicity
- modularity
- maintainability

---

# Control System Research

Current research areas include:
- PID control systems
- trajectory planning
- inverse kinematics
- distributed robotics systems
- reinforcement learning for robotic control

One of the long-term research goals of OpenArm is exploring how reinforcement learning compares with traditional PID tuning methods for low-cost robotic arm systems.

---

# Current Development Priorities

1. Functional actuator testing
2. Lightweight joint design
3. Belt reduction optimization
4. Reliable motion control
5. Power distribution
6. System modularity
7. Manufacturability
8. Documentation

---

# Long-Term Goals

- Fully open-source robotics platform
- Educational robotics accessibility
- Low-cost modular robotics
- Research integration
- School outreach initiatives
- Open-source hardware ecosystem

---

# Current Status

OpenArm is currently in the active prototyping and research phase.
The project continues to evolve through CAD iteration, actuator testing, architecture research, and mechanical prototyping.
