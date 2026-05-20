# OpenArm

<p align="center">
  <img src="Photos/current/OpenArm (1).png" width="700"/>
</p>

<p align="center">
  <em>Open-source 4-DOF robotic manipulation platform — built for accessibility, not industrial performance.</em>
</p>

---

OpenArm is a low-cost open-source robotic arm designed from the ground up to be something students and schools can realistically build, understand, and modify. It started in 2023 with candy sticks and micro servos. It now has a working GNU Octave motion planner, a fully designed 4-DOF arm in CAD, and ongoing research into the engineering tradeoffs between hardware cost, control system complexity, and practical performance.

The goal is not to build the most capable robotic arm possible. The goal is to explore what's achievable with cheap, accessible hardware — and to make that exploration open and reproducible.

---

## Current State

**Simulation (working):**
- 3D inverse kinematics solver in GNU Octave
- Cylindrical-coordinate target selection (top-view + side-view interactive workflow)
- Monte Carlo-style heuristic path planner evaluating ~1000 candidate trajectories per target
- Collision detection against a deadzone box and ground plane
- Cubic smoothstep trajectory interpolation
- Live 3D animation with workspace and deadzone visualization

**Hardware (in progress, not yet built):**
- 4-DOF configuration: base rotation + shoulder + elbow + wrist
- 225mm total reach (three 75mm links)
- NEMA17 stepper motors with HTD belt reductions
- CAN bus distributed actuator architecture (CANBUS-Stepper nodes with integrated ESP32)
- PETG / aluminum hybrid structure
- Designed in Onshape — link in `CAD/README.md`

**Current BOM cost: approximately ₹50,000 INR.** This is too high for the project's goals. The CAN bus stepper modules alone account for ~₹31,200. Bringing this number down significantly is one of the project's active problems. See `BOM.md`.

---

## Why This Project Exists

Most educational robotic arms fall into one of two categories: cheap Arduino servo kits that don't teach real engineering, or expensive platforms that schools can't afford. OpenArm is trying to occupy the space between them — technically serious enough to build real intuition about kinematics, control, and mechanical design, but cheap enough to actually construct and modify.

There's also a research angle that's been driving a lot of the design decisions. Modern robot learning systems may change how much hardware precision you actually need. Industrial arms justify expensive encoders and precision gearing because their controllers assume repeatability. If a robot can learn to compensate for mechanical slop, backlash, and encoder noise through adaptive control or reinforcement learning, maybe the hardware cost calculus changes — and cheap platforms become a lot more viable. This is an open question, not a solved one. See `Research/rl_vs_pid.md` for the current thinking.

The project is self-funded, self-taught, and shaped by years of competitive robotics (FRC, FTC, WRO). Most of the engineering knowledge came from building real robots under pressure and learning what actually matters.

---

## Simulation

The simulator is in `Simulation/openarm_ik.m` and runs in GNU Octave or MATLAB.

```
octave Simulation/openarm_ik.m
```

The interaction is split into two stages per target:

1. **Top view** — click to set the base rotation direction and movement plane
2. **Side view** — click to set radial reach and height

After selecting a target, the planner searches through ~1000 randomly-generated candidate trajectories, collision-checks each one against the deadzone and ground plane, scores valid paths by joint movement and obstacle clearance, then animates the best one.

The planner is slow — several seconds per target on most machines. That's expected for a brute-force heuristic approach. It works well for the current geometry but isn't suitable for real-time use.

See `Simulation/README.md` for the full technical description of the IK solver, motion planner, and collision system.

**Screenshots:** `Simulation/screenshots/`

---

## Research Direction

The central question driving this project: **how much does hardware quality actually matter if you're willing to invest in the control system?**

OpenArm is specifically interested in the tradeoffs between:
- hardware precision and actuator cost
- PID control versus learning-based approaches
- encoder quality and closed-loop control feasibility
- what "good enough" looks like for a manipulator in an educational or light-research context

This is framed as an engineering problem, not an ML research question. Reinforcement learning is a tool — not a solution. Training RL policies on real hardware remains difficult: sample inefficiency, sim-to-real gaps, safety constraints, and the fact that cheap hardware tends to be noisier and less consistent than what most RL robotics papers assume. The project is honest about those challenges.

See `Research/rl_vs_pid.md` for the current analysis of this tradeoff space.

---

## Current Limitations

These are real constraints, not hedged disclaimers:

- **No physical prototype built yet.** The arm has been designed in CAD and fully simulated. No hardware has been assembled or tested.
- **BOM cost is too high** (~₹50,000 INR). Target is significantly lower. The CAN bus stepper modules are the main blocker.
- **Planner is computationally slow.** ~1000 path evaluations per target takes several seconds. Not suitable for real-time or interactive use.
- **No dynamics simulation.** Torque limits, inertia, belt elasticity, and motor acceleration are not modeled. The simulator is purely kinematic.
- **No real-time replanning.** The planner computes a trajectory once per target. There is no replanning on disturbances or new obstacles.
- **No self-collision detection.** Only the deadzone box and ground plane are checked. Link-on-link collisions are not handled.
- **No encoder feedback.** No closed-loop control has been implemented or tested. All IK is open-loop.
- **Torque analysis is static.** Dynamic loading, inertia, and resonance are not yet modeled.

---

## Project Structure

```
Simulation/
  openarm_ik.m             main GNU Octave planner
  README.md                simulation technical reference
  kinematics.md            IK/FK math and coordinate system
  screenshots/             planner visualization screenshots

Research/
  kinematics_reference.md  IK and FK math reference
  motion_planning.md       planning system development notes
  torque_analysis.md       joint torque estimates and actuator feasibility
  executive_summary.md     engineering decisions overview
  joint_design.md          bearing and belt selection
  test_plan.md             test protocol for first hardware prototype
  rl_vs_pid.md             RL vs PID control tradeoff analysis

CAD/
  README.md                Onshape document link and CAD notes

electronics/
  architecture.md          electronics and communication architecture

Photos/
  prototypes/              early candy stick, PVC, and servo prototypes
  current/                 current CAD renders

BOM.md                     bill of materials and cost reduction analysis
Changelog.md               development history
Roadmap.md                 planned development direction
SystemOverview.md          full system architecture overview
CONTRIBUTING.md
```

---

## How This Started

**2023 (7th grade):** Candy sticks, micro servos, cardboard, Arduino. The first version could barely hold its own weight. But figuring out that servo control is harder than it looks was genuinely useful.

**2024:** PVC pipe, hot glue, higher-torque servos. Learned that structural rigidity matters more than motor power at small scales. This version was embarrassing but informative.

**2025:** Moved to Onshape. Proper CAD, gear-driven joints, bearing-supported structure, multi-axis configuration. Started the simulation work to validate geometry before spending money on hardware.

**2026:** CAN bus architecture, NEMA17 steppers, GNU Octave IK planner with Monte Carlo path planning, full deadzone collision system. BOM came in way too expensive. That's where things are now.

---

## Author

Aditya Parikh — Mumbai, India  
adityaparikh09@gmail.com
