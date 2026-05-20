# Electronics Architecture — OpenArm

Design documentation for the OpenArm electronics and communication system.

---

## Overview

The electronics architecture uses a distributed actuator model: each joint has its own intelligent actuator node (a CANBUS-Stepper board with an integrated ESP32, stepper driver, and CAN transceiver). A Raspberry Pi acts as the high-level controller and sends motion commands over CAN bus.

This approach was chosen for:
- **Wiring simplicity:** Each node requires only 2 power wires + 2 CAN wires
- **Scalability:** Adding a joint means adding one node to the CAN chain
- **Modularity:** Individual nodes can be replaced or debugged independently

---

## System Diagram

```
Raspberry Pi (CAN master)
      |
   CAN Bus — twisted pair, 120Ω at both ends
      |
  ┌───┴─────────────────────────┐
  |         |         |         |
Joint 1  Joint 2  Joint 3  Joint 4
(Base)  (Shoulder)(Elbow)  (Wrist)
```

---

## Raspberry Pi

Responsibilities:
- Inverse kinematics and trajectory planning
- Position commands to joint nodes via CAN
- Multi-joint motion coordination
- Future: user interface, ROS2 integration

The Raspberry Pi does not drive motors directly. It communicates intent; the joint nodes handle low-level execution.

---

## CANBUS-Stepper Nodes

Each joint has one CANBUS-Stepper board containing:
- ESP32-based MCU
- Integrated stepper motor driver
- CAN bus transceiver
- Encoder input support (for future closed-loop control)

Each board runs firmware that handles CAN message parsing, stepper pulse generation, current limiting, and eventually encoder reading.

---

## CAN Bus Wiring

**Topology:** Daisy-chain (not star).

```
RPi → Node1 → Node2 → Node3 → Node4
```

**Cable:** Twisted pair for CAN_H and CAN_L. 120Ω termination resistors at both ends of the bus.

Star topologies create impedance discontinuities that cause reflections. Daisy-chain is the correct topology for CAN bus.

---

## Power Distribution

**Main supply:** 24V DC, ~10A (MeanWell LRS-350-24 or equivalent). Stepper drivers run from 24V directly.

**Logic supply:** 24V → 5V buck converter for the Raspberry Pi. ~10W continuous.

**Protection:** 10A slow-blow fuse on the 24V line.

```
24V PSU
  ├── 10A fuse
  ├── Joint 1–4 (+24V, GND)
  └── Buck converter (+24V) → 5V → Raspberry Pi
```

---

## Encoder Integration (Planned)

Magnetic encoders on each joint for closed-loop control:

| Encoder | Resolution | Interface | Notes |
|---|---|---|---|
| AMS AS5600 | 12-bit (4096 CPR) | I2C / PWM | Low cost, adequate for initial testing |
| AMS AS5047D | 14-bit (16384 CPR) | SPI / ABI | Better resolution, higher cost |

Encoder magnet mounted coaxially on joint output shaft. Magnet-to-sensor gap: 0.5–3mm per datasheet. This is a tight mechanical tolerance that must be enforced in CAD.

**Initial control mode:** Open-loop stepping. Validate kinematics first, add closed-loop control after.

---

## Message Protocol

Standard 11-bit CAN identifiers.

| Direction | ID | Content |
|---|---|---|
| Master → Node | 0x101–0x104 | SET_TARGET_POS, SET_STEP_RATE, SET_CURRENT_LIMIT, STOP |
| Node → Master | 0x201–0x204 | STATUS (position, temperature, error flags) |

Node IDs: Base=1, Shoulder=2, Elbow=3, Wrist=4.

---

## Current Status

Designed but not yet assembled. First milestone: single-joint testbed to validate motor, belt, encoder, and CAN communication before building the full arm.

See `Research/test_plan.md` for the test protocol.
