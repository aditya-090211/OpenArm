# OpenArm Electronics & System Architecture

## Overview

OpenArm uses a distributed actuator architecture designed to simplify wiring, improve modularity, and create a scalable robotics platform.

The system is built around:
- CANBUS-Stepper actuator controllers
- NEMA17 stepper motors
- Raspberry Pi high-level control
- CAN communication
- External 24V power distribution

The primary goals of the architecture are:
- modularity
- simplified wiring
- scalability
- maintainability
- educational accessibility

---

# High-Level System Architecture

```text
Raspberry Pi
      │
      ▼
CAN Bus Network
 ├── Joint 1 (Base)
 ├── Joint 2 (Shoulder)
 ├── Joint 3 (Elbow)
 └── Joint 4 (Wrist)
```

Each joint acts as an independent intelligent actuator node.

---

# Main System Components

## Raspberry Pi

The Raspberry Pi acts as the high-level controller and is responsible for:
- motion coordination
- inverse kinematics
- trajectory planning
- actuator communication
- future robotics software integration

The Raspberry Pi does NOT directly drive motors.

---

# CANBUS-Stepper Nodes

Each actuator node contains:
- local ESP32-based control
- integrated stepper driver
- CAN communication
- encoder support
- local motor control logic

Advantages of this architecture:
- cleaner wiring
- modular joints
- easier debugging
- easier actuator replacement
- scalable robotics architecture

---

# Communication Architecture

The communication system is based on:
- CAN bus communication
- daisy-chained actuator nodes

Advantages:
- low wiring complexity
- robust communication
- scalability
- modularity
- cleaner cable management

---

# Power Distribution

The current system uses:
- external 24V PSU
- centralized power distribution
- local actuator control electronics

Power architecture:

```text
24V PSU
 ├── CANBUS-Stepper Chain
 └── 24V → 5V Buck Converter → Raspberry Pi
```

---

# Wiring Philosophy

The system prioritizes:
- reduced wire count
- modularity
- serviceability
- clean routing
- simplified assembly

Each actuator node only requires:
- power pair
- CAN pair

This significantly reduces wiring complexity compared to traditional robotics systems.

---

# Motor Configuration

Current planned motor configuration:

| Joint | Motor Type |
|---|---|
| Base | Standard NEMA17 |
| Shoulder | Standard NEMA17 |
| Elbow | Pancake NEMA17 |
| Wrist | Pancake NEMA17 |

---

# Encoder Integration

The current actuator system supports:
- magnetic encoders
- closed-loop control capability

Current development strategy:
- open-loop initial testing
- closed-loop integration later

---

# Future Development

Planned future improvements include:
- advanced closed-loop control
- distributed synchronization
- ROS2 integration
- advanced trajectory planning
- reinforcement learning experimentation
- modular sensor integration

---

# Current Priorities

1. Reliable actuator testing
2. Stable CAN communication
3. Lightweight wiring
4. Power distribution reliability
5. Mechanical integration
6. Modular architecture
7. Manufacturability

---

# Current Status

The electronics architecture is currently in active prototyping and development.
