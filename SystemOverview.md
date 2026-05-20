# System Overview — OpenArm

A technical overview of the full OpenArm system architecture. Covers mechanical, electronics, software, and communication layers.

---

## Configuration

**Degrees of freedom:** 4 (base rotation + shoulder + elbow + wrist)

**Geometry:**
- L1 = L2 = L3 = 75 mm (shoulder, elbow, wrist links)
- Total maximum reach: 225 mm
- Shoulder offset from base rotation axis: 31.64 mm
- Shoulder height: 55 mm

---

## Mechanical Architecture

**Structure:** Hybrid PETG-CF printed components + aluminum reinforcement at structural nodes.

**Joint design:** Each joint uses a shaft supported by deep-groove ball bearings (625ZZ or 606ZZ), driven by an HTD-5M timing belt and pulley reduction.

**Motor configuration:**

| Joint | Motor | Reduction Ratio |
|---|---|---|
| Base | NEMA17 Standard (42×48mm) | 5:1 |
| Shoulder | NEMA17 Standard (42×48mm) | 5–7:1 |
| Elbow | NEMA17 Pancake (23mm stack) | 5:1 |
| Wrist | NEMA17 Pancake (23mm stack) | 3–5:1 |

Pancake motors at distal joints reduce mass and rotational inertia where the torque requirement is low.

See `Research/torque_analysis.md` for torque estimates and `Research/joint_design.md` for bearing and belt selection.

---

## Electronics Architecture

```
Raspberry Pi (high-level controller)
      |
   CAN Bus (daisy chain, 120Ω termination at both ends)
      |
  ┌───┴──────────────────────────────────┐
  |         |           |               |
Joint 1  Joint 2    Joint 3         Joint 4
(Base)  (Shoulder)  (Elbow)         (Wrist)

Each joint: CANBUS-Stepper node
            ├── ESP32-based MCU
            ├── Integrated stepper driver
            ├── CAN transceiver
            └── Encoder support (AS5600 or AS5047D)
```

**Power distribution:**

```
24V PSU (MeanWell LRS-350-24 or equivalent)
  ├── 10A slow-blow fuse
  ├── CANBUS-Stepper chain (4 nodes, 24V direct)
  └── 24V → 5V buck converter → Raspberry Pi
```

---

## Software Architecture

**High-level controller (Raspberry Pi):**
- Inverse kinematics computation
- Trajectory planning and interpolation
- CAN bus communication (motion commands to each joint node)
- Eventually: encoder feedback processing, closed-loop coordination

**Joint nodes (CANBUS-Stepper):**
- Local stepper driver control
- CAN message parsing and response
- Encoder reading (future)
- Local closed-loop control (future)

**Simulation (GNU Octave):**
- Full FK/IK model
- Heuristic motion planner
- Collision detection
- Trajectory visualization
- Development and validation environment before hardware deployment

The simulation and hardware control share the same kinematic math. The Octave implementation serves as the reference model; firmware implementations will follow the same equations.

---

## Communication Protocol

**CAN bus:** Standard 11-bit IDs, 1 Mbit/s.

| Direction | CAN ID | Message |
|---|---|---|
| Master → Node | 0x101–0x104 | SET_TARGET_POS, SET_STEP_RATE, SET_CURRENT_LIMIT, STOP |
| Node → Master | 0x201–0x204 | STATUS (position, temperature, error flags) |

Node IDs: Base=1, Shoulder=2, Elbow=3, Wrist=4.

**Initial control mode:** Open-loop stepping (no encoder feedback), for kinematic validation. Closed-loop PID to follow once encoders are integrated.

---

## Simulation Reference

The simulation implements the full FK/IK pipeline and a Monte Carlo-style motion planner. See `Simulation/README.md` for how to run it and `Simulation/kinematics.md` for the math.

**Current simulation state:** Working. Interactive, 3D, with collision detection and trajectory animation.

**Hardware state:** Not yet fabricated. CAD is in progress in Onshape (link in `CAD/README.md`).
