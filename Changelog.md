# Changelog

---

## v0.1 — November 2023

First prototype. Candy sticks, micro servos, cardboard, Arduino Uno. The arm could move two joints and barely hold its own weight. Built primarily to understand servo control and basic arm kinematics before dealing with anything more complex. Most of the learning at this stage was about mechanical linkages and why rigidity matters.

---

## v0.2 — 2024

PVC pipe and hot glue structural prototype. Moved to higher-torque servos. Better range of motion, better structural integrity (relative to candy sticks). Started thinking seriously about gear systems and modularity. This version could hold a pose without drooping.

---

## v0.3 — 2025

**Transition to CAD-based development in Onshape.**

Multiple design iterations covering:
- Gear-driven joint concepts
- Bearing-supported joints
- Multi-axis arm configurations
- Improved gripper designs
- Modular link architecture

Also started the simulation work. First version was a simple 2D FK/IK implementation in MATLAB/Octave — just proving the math worked.

---

## v0.4 — Early 2026

**OpenArm GitHub repository initialized.**

Architecture settled on CAN bus distributed stepper system. Key decisions:
- NEMA17 steppers (standard proximal, pancake distal)
- HTD-5M belt reductions
- CANBUS-Stepper nodes (ESP32 + stepper driver + CAN)
- Raspberry Pi as high-level controller
- 4-DOF: base + shoulder + elbow + wrist
- 225mm total reach (3× 75mm links)

BOM came in at ~₹50,000. Significantly higher than target.

---

## Simulation Development — 2026

Detailed timeline of simulation development:

**2D Planar Simulator (initial):**
- FK and IK for 3-link planar arm
- Workspace visualization
- Basic smoothstep interpolation

**3D Extension:**
- Added base rotation
- Cylindrical coordinate target selection (top-view + side-view workflow)
- 3D visualization
- Shoulder offset modeling (31.64mm from base axis)

**Collision System:**
- Ground plane detection
- Deadzone box modeling (180mm × 100mm × 57mm + 8mm margin)
- Dense link sampling (25 points per link segment)
- Trajectory-continuous collision checking

**Motion Planner:**
- Monte Carlo-style heuristic search (~1000 candidates per target)
- 7 trajectory strategy modes (direct, arc, retract, random offset, etc.)
- Path scoring by joint movement + obstacle clearance
- Selection of lowest-cost valid trajectory

**Current bugs / known issues:**
- Planner is slow (3–10 seconds per target)
- No self-collision detection
- No joint angle limits enforced
- No dynamics

---

## Current Status — May 2026

- Simulation: working, actively used for development
- CAD: in progress in Onshape, not yet fabricated
- Hardware: no physical prototype built yet
- Cost: too high, cost reduction research ongoing
