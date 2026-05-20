# Torque Analysis — OpenArm

Ongoing torque estimates, weight analysis, and actuator feasibility for OpenArm. This is engineering work in progress — numbers will be revised as the physical prototype develops and actual part weights become known.

---

## Why This Matters

In a robotic arm, every gram distal to a joint creates a torque that the motor must overcome. This compounds: the shoulder has to support the elbow motor, the elbow link, the wrist motor, the wrist link, and anything attached to the end effector. Even a small arm can surprise you with how quickly the torque requirements add up.

Getting this wrong in either direction is costly: underpowered motors miss steps or stall, while oversizing adds weight and cost. For OpenArm specifically, weight is doubly important because we're using belt reductions rather than high-ratio gearboxes — there's no harmonic drive multiplication to hide motor sizing mistakes.

---

## Current Architecture

- 4-DOF: base, shoulder, elbow, wrist
- NEMA17 stepper motors (standard proximal, pancake distal)
- HTD belt reductions (target ratio: 5:1 to 7:1)
- PETG / aluminum hybrid structure

---

## Mechanical Assumptions

These are estimates. The physical prototype will produce better numbers.

| Parameter | Value | Notes |
|---|---|---|
| L1 (shoulder-to-elbow) | 75 mm | CAD spec |
| L2 (elbow-to-wrist) | 75 mm | CAD spec |
| L3 (wrist-to-EE) | 50 mm | Approximate |
| Link mass (each) | ~65 g | 3mm Al + printed parts |
| Standard NEMA17 mass | ~300 g | Typical for 42×48mm |
| Pancake NEMA17 mass | ~200 g | Typical for 23mm stack height |
| Total moving arm mass | ~340 g | Sum of above, rough estimate |

---

## Static Torque Calculations

Worst-case static load: arm fully horizontal, gravity acting perpendicular to each link.

Torque equation:

$$\tau = m \cdot g \cdot d$$

where $m$ is the mass beyond the joint, $g = 9.81\ \text{m/s}^2$, and $d$ is the moment arm (distance to center of mass).

Force on shoulder from full distal arm mass:

$$F = m \cdot g = 0.34\ \text{kg} \times 9.81\ \text{m/s}^2 \approx 3.34\ \text{N}$$

The mass is distributed, not concentrated at the tip. Assuming center of mass at roughly 75mm from the shoulder pivot:

$$\tau_{shoulder} = 3.34\ \text{N} \times 0.075\ \text{m} \approx 0.25\ \text{Nm}$$

Per-joint breakdown (with 2x safety factor for dynamics):

| Joint | Mass Beyond (kg) | Moment Arm (m) | Static Torque (Nm) | With SF=2 (Nm) |
|---|---|---|---|---|
| Base | 0.865 (full arm) | 0.075 | 0.64 | 1.28 |
| Shoulder | 0.50 | 0.075 | 0.37 | 0.74 |
| Elbow | 0.23 | 0.075 | 0.17 | 0.34 |
| Wrist | 0.03 | 0.050 | 0.015 | 0.03 |

The 2x safety factor is a rough estimate intended to cover dynamic loads from acceleration. Real dynamic torques depend on motion profiles, and have not been modeled properly yet.

---

## NEMA17 Feasibility

Standard NEMA17 (42×48mm) holding torque: approximately 0.4–0.6 Nm depending on driver current and stepping mode.

With a 5:1 belt reduction, the motor only sees 1/5 of the joint torque:

$$\tau_{motor} = \frac{\tau_{joint}}{n} = \frac{0.74}{5} \approx 0.15\ \text{Nm}$$

This is comfortably within the motor's capability. A 7:1 reduction gives more headroom. Wrist torque is negligible either way.

**Current conclusion:** NEMA17 steppers should be adequate for the current arm geometry and estimated masses, assuming reasonable belt reductions and careful driver current tuning.

---

## What Static Analysis Misses

Static holding torque is the easy part. The harder problems are:

**Dynamic loading:** Accelerating the arm creates inertial loads beyond what gravity alone produces. At aggressive accelerations, these can exceed the static load significantly. Not modeled yet.

**Resonance:** Belt-drive systems have elastic compliance. If the controller drives at or near a resonant frequency, vibration and step loss can occur even at torques well below stall. Need actual belt stiffness data to model this properly.

**Structural flex:** The arm deflects under load. Flex makes end effector position uncertain regardless of joint angle accuracy. This is likely to be the dominant error source on the first prototype, and is not captured in any of the numbers above.

**Backlash:** Belt drives have some backlash. Even 1–2° of backlash is significant at 225mm reach — it translates to roughly 4–8mm of end effector position error.

None of these are modeled yet. Hardware testing will be the real source of truth.

---

## Why Lightweight Design Matters (Belt-Drive Context)

With belt reductions of 5–7:1, we get meaningful torque multiplication, but not the 50–100:1 ratios of harmonic drives or precision gearboxes. This means distal mass matters a lot:

- Every gram at the wrist adds directly to elbow and shoulder loading.
- Motor sizing can't compensate for poor weight distribution.
- The arm should be designed to minimize mass from the elbow outward.

The pancake NEMA17 choice for elbow and wrist is specifically motivated by this. A pancake motor trades some holding torque for a 30–40% reduction in mass and rotational inertia — the right tradeoff for distal joints where the torque requirement is low anyway.

---

## Material Strategy

Current:
- Aluminum reinforcement at structural nodes
- PETG-CF for printed structural components
- Bearing-supported joints

Aluminum adds stiffness-to-weight ratio beyond what PETG alone provides, particularly at the shoulder bracket where structural flex directly affects end effector repeatability. The trade is slightly higher cost and harder fabrication. This is probably worth it for the shoulder and first link; the distal links can likely be printed only.

---

## Known Gaps

- No rotational inertia estimates for motors and links
- No resonance analysis or belt stiffness modeling
- No acceleration-limited torque analysis
- No payload analysis
- No thermal analysis (motor current vs. temperature over time)

These will be addressed once hardware testing begins. The current analysis is only sufficient to validate actuator selection — not to predict real-world performance.
