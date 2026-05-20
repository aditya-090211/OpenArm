# Motion Planning — Research Notes

Development notes on the OpenArm simulation and motion planning system. Covers the progression from basic FK to the current heuristic Monte Carlo planner, including what broke along the way.

---

## Why Simulation Before Hardware

The simulation was built before any hardware because physical iteration is expensive and slow. CAD changes are frequent at this stage, and it's much easier to find kinematic errors in software than after cutting aluminum.

The simulator serves as:
- a sandbox for testing IK algorithms and motion planners
- a validation environment for arm geometry before fabrication
- a visualization tool for understanding workspace and collision behavior
- eventually, a development environment for hardware-in-the-loop testing

---

## Development History

### Early 2D Simulator

The first version was purely 2D — shoulder, elbow, wrist, no base rotation. Goals were minimal: prove that the IK math was correct and that the arm geometry made sense.

No collision checking. No trajectory planning. No visualization beyond a static plot. Just FK/IK and a workspace sweep.

The main value was establishing that the law-of-cosines IK approach worked and catching mistakes in the shoulder offset model early.

### Adding Base Rotation (3D)

Extending to 3D introduced the cylindrical coordinate system. The key insight was to separate the problem:

1. Solve base rotation from the target's XY position: $\theta_{base} = \text{atan2}(y, x)$
2. Reduce to a 2D planar IK problem in the arm's local plane

This decomposition significantly simplifies the IK solver — you never need to solve a full 3D IK system, just a 2D three-link chain.

The transition to 3D also introduced the shoulder offset. The shoulder motor is not centered on the base rotation axis — it's offset by 31.64mm. Ignoring this makes the simulation visually wrong and produces incorrect reach calculations near the base.

---

## Coordinate System

Target selection uses a two-step cylindrical workflow:

**Step 1 — Top view:** User clicks to select base rotation direction and movement plane.

$$\theta_{base} = \text{atan2}(y, x)$$

**Step 2 — Side view:** User clicks to select radial reach and height.

$$r = \text{selected radial distance}, \quad z = \text{selected height}$$

Cylindrical to Cartesian conversion:

$$x_t = r \cos(\theta_{base}), \quad y_t = r \sin(\theta_{base})$$

This workflow maps naturally to the robot's physical structure and makes targeting easier to reason about than direct XYZ input.

---

## Inverse Kinematics

The IK solver is a standard analytical 3-link solution using the law of cosines. Full derivation in `Research/kinematics_reference.md`.

Target-relative coordinates (from shoulder):

$$d_x = r - d_{offset}, \quad d_z = z_t - h_{shoulder}$$

End effector orientation:

$$\theta_{ee} = \text{atan2}(d_z, d_x)$$

Wrist position (subtracting L3 from end effector):

$$w_x = d_x - L_3 \cos(\theta_{ee}), \quad w_z = d_z - L_3 \sin(\theta_{ee})$$

Elbow angle via law of cosines:

$$D = \frac{w_x^2 + w_z^2 - L_1^2 - L_2^2}{2 L_1 L_2}$$

$$\theta_2 = \text{atan2}(\pm\sqrt{1-D^2},\ D)$$

Shoulder angle:

$$\theta_1 = \text{atan2}(w_z, w_x) - \text{atan2}(L_2\sin(\theta_2),\ L_1 + L_2\cos(\theta_2))$$

Wrist angle:

$$\theta_3 = \theta_{ee} - \theta_1 - \theta_2$$

Two solutions exist (elbow-up and elbow-down). The solver selects the one with lower total angular movement from the current state.

---

## Trajectory Interpolation

Joint angles are interpolated using cubic smoothstep rather than linear interpolation:

$$s(t) = 3t^2 - 2t^3, \quad t \in [0, 1]$$

$$\theta(t) = \theta_{start} + s(t)(\theta_{target} - \theta_{start})$$

This produces smooth acceleration and deceleration with zero velocity at both endpoints. Each trajectory segment uses 45 interpolation steps.

Smoothstep is adequate for visualization but not rigorous for real hardware — it doesn't enforce velocity or acceleration limits, and has a discontinuity in acceleration at the transition points. A proper implementation would use a trapezoidal or S-curve velocity profile.

---

## Collision Detection

Two collision volumes are checked:

**Ground plane:** Any link point with $z < 0$ is a collision.

**Deadzone box:** The arm's base assembly (motors, belts, structure) occupies a physical volume that the links must not enter. Modeled as an axis-aligned bounding box:

$$x \in [x_{min}, x_{max}], \quad y \in [y_{min}, y_{max}], \quad z \in [z_{min}, z_{max}]$$

Current deadzone dimensions: 180mm × 100mm × 57mm, with an 8mm safety margin.

Each link is sampled densely (25 points per segment, 2 distal links checked) at every trajectory step:

$$p(t) = p_{start} + t(p_{end} - p_{start}), \quad t \in [0, 1]$$

Only the two distal links are sampled. The base link is always inside the deadzone by design.

### Problems Encountered

**Ground penetration:** Early versions frequently drove the arm below the ground plane during transitions. Fixed by adding the ground collision check and filtering invalid configurations during path search.

**Deadzone clipping:** Some trajectories that appeared collision-free in endpoint checks were actually clipping corners of the deadzone during interpolation. Fixed by increasing sampling density and checking continuously throughout the trajectory, not just at endpoints.

**Invalid reachable targets:** Some targets that were clearly within the workspace were being rejected as unreachable. This was caused by incorrect wrist orientation assumptions — the end effector angle calculation was off by a sign in some quadrants, which drove the wrist position outside the 2-link reach circle even for reachable targets.

---

## Heuristic Motion Planner

A direct IK solution to the target is often not sufficient: the arm may collide during motion, or the intermediate states may be physically problematic. Instead of computing a single direct trajectory, the planner:

1. Generates ~1000 candidate waypoint sequences
2. Solves IK for each waypoint
3. Collision-checks each trajectory continuously
4. Scores valid trajectories by cost
5. Selects the lowest-cost valid path

### Candidate Generation

Seven trajectory strategies are sampled randomly per attempt:

| Mode | Description |
|---|---|
| 1 | Direct trajectory to target |
| 2 | Lift above target, then descend |
| 3 | Retract to near-vertical, then extend |
| 4 | Partial retract with elevation |
| 5 | Random angle offset approach |
| 6 | High arc over target |
| 7 | Wide offset approach |

The random variation within each mode is important — it allows the planner to find trajectories that avoid specific obstacle configurations that a purely deterministic set of strategies would miss.

### Path Scoring

Each valid trajectory is scored by:

$$C = \sum |\Delta\theta_i| + \lambda \left(\frac{1}{d_{collision}}\right)$$

where $d_{collision}$ is the minimum distance from any link point to the nearest collision volume boundary, and $\lambda$ is a weighting factor (currently 0.02).

This encourages:
- minimal joint movement (smoother, more energy-efficient motion)
- trajectories that stay farther from obstacles

### Performance

The planner evaluates approximately 1000 candidates per target. Each candidate involves:
- IK solving for each waypoint (2 solutions each, pick minimum cost)
- Full trajectory generation (45 steps per segment)
- Dense collision checking (25 samples × 2 links × 45 steps per segment)

On a typical laptop, planning takes 3–10 seconds depending on target position and trajectory complexity. This is not suitable for real-time use. It's a brute-force search, not an efficient planner.

The approach was chosen because it's flexible and easy to extend. Adding a new trajectory strategy is just adding a new case to the mode switch. A proper planner (RRT, CHOMP, etc.) would be more efficient but significantly harder to implement and debug.

---

## Visualization

The simulator renders:
- Ground plane
- Deadzone box (semi-transparent red)
- Full 3D arm with 4 joints
- Target point
- Live animation of the planned trajectory

The visualization turned out to be critical for debugging. Several bugs that would have been very hard to find mathematically were immediately obvious visually — like trajectories that technically passed collision checks but looked obviously wrong.

---

## Current Limitations

**No global planner.** The current system is a heuristic search, not a mathematically complete planner. It works well for the current geometry and obstacle configuration, but there's no guarantee of finding a path when one exists.

**No self-collision.** Links can pass through each other. This is not a problem for the current 4-DOF configuration in most configurations, but will matter as the design evolves.

**No dynamics.** Torque limits, inertia, and acceleration constraints are not modeled. The planner will generate trajectories that are kinematically valid but might be impossible for the hardware to execute at the commanded speed.

**No real-time capability.** Several seconds per plan is fine for interactive use but incompatible with any real-time control application.

**Simplified collision geometry.** Only a box and a plane. No mesh collision, no swept-volume analysis.

---

## Future Directions

Things worth exploring once hardware is available:

- Acceleration-limited motion profiles (trapezoidal or S-curve velocity)
- Self-collision detection using capsule approximations of each link
- Online replanning for disturbance rejection
- Hardware-in-the-loop simulation using CAN bus
- RL-based trajectory optimization (see `Research/rl_vs_pid.md`)
