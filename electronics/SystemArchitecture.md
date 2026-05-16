# OpenArm Electronics & System Architecture

## Overview

OpenArm uses a distributed actuator architecture designed to simplify wiring, improve modularity, and make the robotic arm easier to expand and maintain.

The system is built around:
- CANBUS-Stepper actuator controllers
- NEMA17 stepper motors
- Raspberry Pi high-level control
- Distributed CAN communication
- External 24V power distribution

---

# High-Level Architecture

```text
Raspberry Pi
      │
      ▼
CAN Bus Network
 ├── Joint 1 (Base)
 ├── Joint 2 (Shoulder)
 ├── Joint 3 (Elbow)
 └── Joint 4 (Wrist)
