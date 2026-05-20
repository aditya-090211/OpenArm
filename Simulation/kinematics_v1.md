# Simulation Notes — Early Version

Early notes from the first (2D planar) simulation. Kept for reference.

The current simulation documentation is in:
- `Simulation/README.md` — how to run the simulation and architecture overview
- `Simulation/kinematics.md` — full 3D kinematic model reference

---

## What the Early Simulator Covered

The initial simulation was purely 2D — no base rotation, no 3D visualization. It implemented:

- Forward kinematics for a 3-link planar arm
- Basic inverse kinematics (law of cosines)
- Workspace visualization
- Smoothstep trajectory interpolation
- End-effector trajectory plotting
- Basic position error analysis

The goal was just to validate that the IK math worked before extending to 3D. No collision detection, no motion planning.

---

## What Changed

The 3D extension added base rotation, cylindrical coordinate target selection, the shoulder offset model, the deadzone collision system, and the Monte Carlo motion planner. These are all documented in the current simulation files.

The FK/IK math is the same — the 3D version just adds the base rotation layer on top of the same 2D planar solver.
