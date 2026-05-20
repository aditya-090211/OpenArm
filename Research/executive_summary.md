# Engineering Overview — OpenArm

A summary of the key engineering decisions in the current OpenArm design. This covers actuator selection, power architecture, mechanical design, and control system planning.

---

## Joint Torque and Transmission

Worst-case joint torques were estimated by summing the moment of all mass beyond each joint, assuming fully horizontal arm configuration. Each link is approximately 75mm long, with ~65g link mass (3mm aluminum + printed parts) and distal motor mass of ~200–300g depending on joint.

Static torque estimates (before gearing):

| Joint | Mass Beyond (kg) | Static Torque (Nm) | With 2x Safety Factor |
|---|---|---|---|
| Base | 0.865 | 0.64 | 1.28 |
| Shoulder | 0.50 | 0.37 | 0.74 |
| Elbow | 0.23 | 0.17 | 0.34 |
| Wrist | 0.03 | 0.015 | 0.03 |

With a 5:1 belt reduction, the shoulder motor sees approximately 0.15 Nm — well within the 0.4 Nm holding torque of a standard NEMA17. A 7:1 reduction gives additional margin.

The 2x safety factor is a rough estimate for dynamic loads. Full inertia and dynamic analysis has not been completed.

Full analysis in `Research/torque_analysis.md`.

---

## Actuator and Encoder Selection

All joints use stepper motors. Steppers were chosen for:
- High holding torque at low speed
- Simple open-loop control during initial development
- Wide availability and reasonable cost in India

Standard NEMA17 (42×48mm, ~0.4 Nm) on proximal joints (base, shoulder). Pancake NEMA17 (~0.16 Nm, ~200g) on distal joints (elbow, wrist) to reduce distal mass and inertia.

| Motor Type | Holding Torque | Mass | Use |
|---|---|---|---|
| NEMA17 42×48mm | ~0.4 Nm | ~300 g | Base, Shoulder |
| NEMA17 Pancake 23mm | ~0.16 Nm | ~200 g | Elbow, Wrist |

**Encoders:** Magnetic absolute encoders are planned for closed-loop control in later revisions. Options currently being evaluated:

| Encoder | Resolution | Interface | Notes |
|---|---|---|---|
| AMS AS5047D | 14-bit (16384 CPR) | SPI/ABI | Good resolution, higher cost |
| AMS AS5600 | 12-bit (4096 CPR) | I2C/PWM | Cheaper, adequate for initial testing |
| Incremental optical | 500–1000 PPR | Quadrature | Lowest cost, requires index reference for homing |

Initial hardware testing will run open-loop to validate kinematics before adding closed-loop complexity.

---

## Power and Wiring Architecture

**Power supply:** Single 24V DC supply, ~10A capacity (MeanWell LRS-350-24 or equivalent). All stepper drivers run directly from 24V.

**Logic supply:** A 24V-to-5V buck converter powers the Raspberry Pi. Sized for ~10W continuous.

**CAN bus wiring:** Daisy-chain topology (not star). Twisted pair for CAN_H/CAN_L, 120 Ω termination resistors at both ends of the bus. Each actuator node requires only two signal wires (CAN_H, CAN_L) plus power — a significant reduction in wiring complexity compared to parallel stepper wiring.

```
24V PSU
 ├── Fuse (10A slow-blow)
 ├── CANBUS-Stepper chain (4 nodes, daisy-chained)
 └── 24V → 5V buck → Raspberry Pi
```

---

## Joint Mechanical Design

Each joint uses deep-groove ball bearings and a timing-belt/pulley reduction:

- **625ZZ bearings:** 5mm ID × 16mm OD × 5mm — most joint pivots
- **606ZZ bearings:** 6mm ID × 17mm OD × 6mm — base rotation
- **HTD-5M timing belts** with pulley ratios in the 5:1 to 7:1 range

Fasteners: M3 metric throughout. Bearings pressed into 3D-printed hubs with appropriate interference fit. Cable routing planned through hollow joint profiles where possible.

---

## Control and Communication Architecture

**Master controller:** Raspberry Pi, responsible for inverse kinematics, trajectory planning, and CAN bus coordination.

**CAN nodes:** One CANBUS-Stepper board per joint (four total), each with a unique node ID. Planned message set:

- `SET_TARGET_POS` — absolute angle target
- `SET_STEP_RATE` — velocity limit
- `SET_CURRENT_LIMIT`
- `STOP`
- Status reply: current position, errors, temperature

**Initial control mode:** Open-loop stepping. This lets kinematic validation happen before adding closed-loop complexity. Closed-loop with encoder feedback is the next planned phase.

CAN arbitration uses standard 11-bit IDs. Joint commands: 0x101–0x104; status replies: 0x201–0x204.

---

## Key Design Decisions

| Decision | Choice | Reason |
|---|---|---|
| Motor type | NEMA17 steppers | Cost, simplicity, adequate torque with belt reduction |
| Communication | CAN bus | Clean wiring, scalable |
| Controller | Raspberry Pi | Sufficient compute for IK and trajectory planning |
| Structure | PETG + aluminum | Accessible manufacturing, adequate stiffness |
| Initial control | Open-loop | Validate kinematics first, add feedback later |
| Encoder (future) | Magnetic absolute | No homing required on power-up |
