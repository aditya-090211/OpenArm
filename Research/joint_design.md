# Joint Mechanical Design — OpenArm

Design notes on bearing selection, belt drive sizing, and joint construction for OpenArm.

---

## Overview

Each joint uses a shaft supported by deep-groove ball bearings and driven by an HTD timing belt/pulley reduction. Design priorities:

- low backlash (belt drives over spur gears)
- minimal distal mass (pancake motors for elbow and wrist)
- accessible fabrication (off-the-shelf bearings, printed hubs, M3 hardware)
- adequate stiffness without requiring machined parts

---

## Bearing Selection

| Bearing | ID | OD | Width | Application |
|---|---|---|---|---|
| 625ZZ | 5 mm | 16 mm | 5 mm | Most joint pivots |
| 606ZZ | 6 mm | 17 mm | 6 mm | Base rotation |
| 608ZZ | 8 mm | 22 mm | 7 mm | Shoulder (under evaluation) |

Bearings are pressed into 3D-printed hubs. Target interference fit: 0.1–0.2mm on radius. PETG is slightly more compliant than PLA — the press fit tolerance may need adjustment depending on the printer and material. Test prints before committing to final hub geometry.

Double-bearing support is planned at the shoulder pivot to reduce flex under the highest-moment load.

---

## Belt Drive System

**Belt type:** HTD-5M (5mm pitch, 15mm width)

Timing belts were chosen over spur gears for:
- Lower backlash (no gear mesh clearance)
- Quieter operation
- Flexibility in motor placement (motor can be proximal, driving through the belt)
- Easier to manufacture and replace than precision gears

**Preliminary reduction ratios:**

| Joint | Reduction Ratio | Notes |
|---|---|---|
| Base | 5:1 | Higher torque requirement |
| Shoulder | 5–7:1 | Highest static torque joint |
| Elbow | 5:1 | Moderate torque |
| Wrist | 3–5:1 | Low torque, light payload |

These are preliminary. Will be validated once the first prototype is assembled. Belt tension adjusted via sliding motor mount.

---

## Belt Backlash

Two sources:

**Belt elasticity:** The belt stretches slightly under load, allowing the output pulley to lag the input. Load-dependent, not constant. Affected by belt stiffness and pretension.

**Pulley tooth mesh:** Small clearance between belt tooth and pulley groove. HTD profiles manage this better than standard trapezoidal profiles.

At 225mm reach, 1° of effective joint backlash translates to ~2mm end effector uncertainty. Acceptable for casual use. Reducing it requires:
- Proper belt pretension (too loose = more backlash; too tight = high bearing load)
- Aluminum pulleys at proximal joints rather than printed

Printed pulleys have been tested and are usable. Aluminum is worth the cost for shoulder and elbow.

---

## Cable Routing

Planned but not yet finalized in CAD:
- CAN bus and power cables routed through hollow joint shafts where geometry allows
- Strain relief at all flex points
- Minimum bend radius: 5× cable outer diameter

Getting cable routing wrong causes inconsistent friction during joint motion — this is difficult to model or compensate for in the controller. Important to resolve in CAD before fabricating.

---

## Fasteners

M3 metric throughout:
- **DIN7991 countersunk** — joint faces (flush with surface)
- **M3 socket cap** — motor mounts and structural brackets
- **M3 × 6mm hex standoffs** — PCB and electronics mounting

Consistent fastener type reduces tooling and simplifies assembly.

---

## Control and Communication

**CAN message structure** (planned):

| Message | ID | Payload | Direction |
|---|---|---|---|
| SET_TARGET_POS | 0x101–0x104 | Absolute angle | Master → Node |
| SET_STEP_RATE | 0x101–0x104 | Velocity limit | Master → Node |
| GET_STATUS | 0x101–0x104 | Request | Master → Node |
| STATUS_REPLY | 0x201–0x204 | Position, temp, errors | Node → Master |

Node IDs: Base=1, Shoulder=2, Elbow=3, Wrist=4.

---

## Open Questions

1. **Shoulder double-bearing geometry.** CAD needs updating to reflect this. Affects shoulder bracket depth and motor mount position.

2. **Belt idler vs. sliding motor mount.** Sliding mount is simpler but harder to access post-assembly. An idler adds a part but makes tension adjustment easier. Decision pending prototype testing.

3. **Printed vs. aluminum pulleys on proximal joints.** Likely aluminum for shoulder and elbow; printed acceptable for wrist.

4. **Encoder mounting geometry.** Encoder needs to sit directly above the joint axis. Constrains shaft length and bearing spacing. Not yet resolved in CAD.
