# Bill of Materials — OpenArm

Current estimated cost and components for the OpenArm prototype. Cost reduction is one of the project's active problems.

---

## Current Estimated Total

**~₹49,802 INR**

This is significantly higher than the target. The CAN bus stepper modules alone account for ~₹31,200 — roughly 63% of the total.

---

## Current BOM

| Part | Qty | Approx. Cost | Notes |
|---|---|---|---|
| CAN Bus Stepper Modules | 4 | ₹31,200 | Integrated motor + driver + CAN. Primary cost driver. |
| NEMA17 Pancake (23mm) | 2 | ₹2,000 | Distal joints (~₹1,000 each) |
| NEMA17 Standard (42×48mm) | 2 | *(TBD)* | Price needs verification — data entry error in original record |
| 3D Prints (PETG/PETG-CF) | — | ₹2,000 | Filament + print time estimate |
| Aluminum Sheet | — | ₹5,000 | Structural reinforcement |
| HTD-5M Belts | 2 | ₹1,000 | |
| Bearings (625ZZ, 606ZZ) | 6 | ₹3,600 | ~₹600 each |
| 24V Power Supply | 1 | ₹1,000 | MeanWell LRS-350-24 or equivalent |
| Wiring and Connectors | — | ₹2,000 | CAN twisted pair, buck converter, connectors |
| M3 Hardware | — | ₹2,000 | Socket cap, DIN7991 countersunk, standoffs |

*Note on standard NEMA17 entry: the original record had ₹2 listed for 2 motors — clearly a data entry error. These motors may be redundant with the CAN stepper modules (which already include the motor). Architecture decision pending.*

---

## The Cost Problem

At ~₹50,000, this arm is out of range for most educational contexts. The original goal was ₹15,000–20,000 for a buildable, modifiable platform that schools could realistically access.

The problem is structural. The CAN bus stepper modules are genuinely useful — they integrate motor, driver, encoder, and CAN communication into a clean architecture — but at ~₹7,800 per joint they dominate the BOM. Marginal cost savings elsewhere don't fix this.

---

## Cost Reduction Paths

### Replace CAN Steppers with Standard Steppers + Drivers

The highest-leverage change. Replace integrated CAN modules with commodity NEMA17 motors (~₹800) + TMC2209 drivers (~₹300) per joint:

| | CAN Stepper Modules | Standard Steppers |
|---|---|---|
| Cost per joint | ~₹7,800 | ~₹1,100 |
| Wiring | 2-wire CAN per joint | 4-wire motor + step/dir per joint |
| Closed-loop | Built-in | Requires separate encoder + firmware |
| Scalability | Excellent (daisy-chain CAN) | Limited |
| Firmware complexity | Low | Higher |

Estimated savings: ~₹26,800. The arm becomes harder to wire and the firmware becomes more complex, but the total cost drops to roughly ₹20,000–25,000.

### Use Servo-Based Prototype First

Before purchasing any precision hardware, build a kinematic testbed using cheap RC servos (~₹200–500 each) on a printed/PVC structure. Validates control software at ~₹3,000 total. The simulation is already ahead of the hardware anyway — this closes the gap cheaply.

### Reduce Aluminum Usage

Replacing aluminum structural members with PETG-CF printed equivalents where the stiffness requirement is lower (distal links primarily). Risk is reduced rigidity and more flex. Worth evaluating per-joint.

---

## Why the Current BOM Exists

The current architecture was designed around learning and integration quality rather than cost optimization. The CAN bus approach produces a clean, scalable system that's well-suited for developing control software. The first prototype is justified at this cost as a learning platform.

But cost reduction is now a first-order constraint for v2.

**Target for v2:** ₹15,000–20,000 total, 4-DOF, adequate for manipulation and education.
