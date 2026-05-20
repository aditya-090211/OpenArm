# OpenArm Simulation

The OpenArm simulation environment is built in GNU Octave and implements a full kinematic model of the arm with an interactive motion planner. It's the primary development tool right now — no physical hardware has been built yet.

---

## Running the Simulation

**Requirements:** GNU Octave (free, open-source) or MATLAB.

```
octave Simulation/openarm_ik.m
```

No dependencies beyond base Octave/MATLAB. The script uses only built-in functions.

---

## How It Works

The simulator is interactive. Each motion target is selected through two views:

### 1. Top View — Select Direction

A top-down view of the arm workspace. Click anywhere to select the direction the arm will face (base rotation angle). The red box in the center is the deadzone — the arm's base assembly, which must not be entered.

The base angle is calculated as:

$$\theta_{base} = \text{atan2}(y, x)$$

### 2. Side View — Select Reach and Height

A side profile view showing the arm's reach in the selected direction. Click to select radial distance and height. The workspace boundary arc shows the maximum reach. The red box at the left is the deadzone profile.

### 3. Path Planning and Animation

After selecting a target, the planner searches through ~1000 randomly-generated trajectory candidates, collision-checks each one, and animates the best valid path in 3D.

A progress display shows the search in real time. Planning typically takes 3–10 seconds. After the animation, a menu offers another target or exit.

---

## Technical Architecture

### Arm Geometry

```
L1 = L2 = L3 = 75mm
Shoulder offset from base axis: 31.64mm
Shoulder height: 55mm
Deadzone: 180mm × 100mm × 57mm (+ 8mm safety margin)
```

### Inverse Kinematics

Standard analytical 3-link IK using the law of cosines. Full derivation in `Research/kinematics_reference.md`.

The key steps:
1. Convert target to shoulder-relative coordinates
2. Solve end effector orientation
3. Back-calculate wrist position (subtract L3)
4. Solve elbow angle via law of cosines
5. Solve shoulder angle
6. Compute wrist angle from orientation constraint

Two solutions exist (elbow-up, elbow-down). The solver picks the one with lower total joint movement from the current state.

### Trajectory Interpolation

Cubic smoothstep: $s(t) = 3t^2 - 2t^3$

Applied to each joint angle:

$$\theta(t) = \theta_{start} + s(t)(\theta_{target} - \theta_{start})$$

45 steps per trajectory segment. Smooth acceleration and deceleration, zero velocity at endpoints.

### Motion Planner

The planner is heuristic, not optimal. It evaluates ~1000 candidate paths using 7 trajectory strategies:

| Strategy | Description |
|---|---|
| Direct | Straight move to target |
| Lift-then-descend | Rise above target, then drop |
| Retract-and-extend | Pull arm in near-vertical, then extend |
| Partial retract | Mid-height intermediate point |
| Random arc | Randomized offset approach angle |
| High arc | Large elevation then descend |
| Wide offset | Wide angle approach with elevation |

Each candidate is collision-checked against the deadzone and ground plane using dense link sampling (25 points per link segment, checked at every trajectory step). Valid paths are scored by:

$$C = \sum |\Delta\theta_i| + 0.02 \cdot \frac{1}{d_{collision}}$$

The lowest-cost valid path is selected and animated.

### Collision Detection

Two volumes:
- **Ground plane:** $z < 0$
- **Deadzone box:** Axis-aligned bounding box around the base assembly, with 8mm safety margin

Only the two distal links are sampled — the base link sits inside the deadzone by design.

---

## Screenshots

See `Simulation/screenshots/` for examples of the top view, side view, and 3D animation.

---

## Known Limitations

- **Slow:** Planning takes several seconds per target. Not suitable for real-time use.
- **No self-collision:** Links can pass through each other. Not a significant issue for the current 4-DOF geometry in most configurations.
- **No dynamics:** Torque limits, inertia, and motor dynamics are not modeled.
- **No real-time replanning:** One plan per target, computed in advance.
- **Simplified collision geometry:** Only deadzone box and ground plane. No mesh collision.
- **No joint limits:** The IK solver doesn't enforce physical joint angle limits.

---

## File Structure

```
Simulation/
  openarm_ik.m      main planner script
  README.md         this file
  kinematics.md     IK/FK math and coordinate system reference
  kinematics_v1.md  earlier 2D simulation notes
  screenshots/      planner output screenshots
```
