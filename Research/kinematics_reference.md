# Kinematics Reference — OpenArm

This document covers the mathematical foundations of the OpenArm simulation and control system. It's written as a reference for understanding the code in `Simulation/openarm_ik.m`, not as a textbook introduction to robotics.

---

## What Kinematics Actually Is

Kinematics is the study of motion without worrying about forces — just geometry and angles. In robotics, it answers two questions:

- **Forward kinematics (FK):** Given joint angles, where is the end effector?
- **Inverse kinematics (IK):** Given a target position, what joint angles do we need?

FK is straightforward. IK is not — there can be multiple solutions, no solution, or solutions that are geometrically valid but mechanically problematic (e.g., passing through the ground or through the robot's own base).

---

## Coordinate Systems

### Cartesian

Standard 3D space: X (forward/right), Y (left/right), Z (up). Most of the internal math uses Cartesian coordinates.

### Cylindrical

OpenArm uses cylindrical coordinates for target selection because the arm has a rotating base. Instead of specifying (x, y, z) directly, the user selects:

- **θ_base** — which direction the arm faces (rotation around Z)
- **r** — how far out the arm reaches radially
- **z** — height

This separates the base rotation problem from the 2D planar IK problem, which makes both easier to solve and debug.

Conversion from cylindrical to Cartesian:

$$x = r \cos(\theta_{base})$$

$$y = r \sin(\theta_{base})$$

Base angle from a selected direction:

$$\theta_{base} = \text{atan2}(y, x)$$

`atan2` handles all four quadrants correctly, which is why it's used everywhere in robotics instead of plain arctan.

---

## Arm Geometry

OpenArm has four degrees of freedom:

| Joint | Variable | Description |
|---|---|---|
| Base | θ_base | Rotation around vertical Z axis |
| Shoulder | θ_1 | Pitch joint at shoulder |
| Elbow | θ_2 | Pitch joint at elbow |
| Wrist | θ_3 | Pitch joint at wrist |

Link lengths (current design):

$$L_1 = L_2 = L_3 = 75 \text{ mm}$$

Total maximum reach: 225 mm.

The shoulder is not at the center of the base rotation axis — it's offset horizontally. This is an important detail that makes the simulation more accurate relative to the actual CAD:

$$x_s = d_{offset} \cos(\theta_{base}), \quad d_{offset} = 31.64 \text{ mm}$$

$$y_s = d_{offset} \sin(\theta_{base})$$

$$z_s = h_{shoulder} = 55 \text{ mm}$$

---

## Forward Kinematics

FK chains outward from the shoulder joint. In the arm's local planar coordinate system (radial and vertical):

**Elbow position:**

$$p_{x1} = L_1 \cos(\theta_1)$$

$$p_{z1} = L_1 \sin(\theta_1)$$

**Wrist position:**

$$p_{x2} = p_{x1} + L_2 \cos(\theta_1 + \theta_2)$$

$$p_{z2} = p_{z1} + L_2 \sin(\theta_1 + \theta_2)$$

**End effector position:**

$$p_{x3} = p_{x2} + L_3 \cos(\theta_1 + \theta_2 + \theta_3)$$

$$p_{z3} = p_{z2} + L_3 \sin(\theta_1 + \theta_2 + \theta_3)$$

Converting back to 3D Cartesian (accounting for shoulder offset and base rotation):

$$x = x_s + p_x \cos(\theta_{base})$$

$$y = y_s + p_x \sin(\theta_{base})$$

$$z = z_s + p_z$$

---

## Inverse Kinematics

IK is harder. Given a target in 3D space, we need to find θ_1, θ_2, θ_3 that put the end effector there.

### Step 1 — Convert target to shoulder-relative cylindrical coordinates

Radial distance from base axis:

$$r = \sqrt{x_t^2 + y_t^2}$$

Shoulder-relative coordinates:

$$d_x = r - d_{offset}$$

$$d_z = z_t - h_{shoulder}$$

Distance from shoulder to target:

$$d = \sqrt{d_x^2 + d_z^2}$$

If $d > L_1 + L_2 + L_3$, the target is unreachable.

### Step 2 — Desired end effector orientation

The wrist is not the end effector. Solve the orientation by pointing naturally toward the target:

$$\theta_{ee} = \text{atan2}(d_z, d_x)$$

### Step 3 — Solve for wrist position

Working backward from the end effector to the wrist simplifies the problem from a 3-link chain to a 2-link chain:

$$w_x = d_x - L_3 \cos(\theta_{ee})$$

$$w_z = d_z - L_3 \sin(\theta_{ee})$$

Check that the wrist is reachable by the first two links: $\sqrt{w_x^2 + w_z^2} \leq L_1 + L_2$.

### Step 4 — Solve elbow angle using law of cosines

$$D = \frac{w_x^2 + w_z^2 - L_1^2 - L_2^2}{2 L_1 L_2}$$

$D$ is clamped to $[-1, 1]$ to prevent numerical errors near singular configurations.

Elbow angle (two solutions — elbow-up and elbow-down):

$$\theta_2 = \text{atan2}\left(\pm\sqrt{1 - D^2},\ D\right)$$

### Step 5 — Solve shoulder angle

$$\theta_1 = \text{atan2}(w_z, w_x) - \text{atan2}\left(L_2 \sin(\theta_2),\ L_1 + L_2 \cos(\theta_2)\right)$$

### Step 6 — Solve wrist angle

The wrist angle keeps the end effector pointing in the desired direction:

$$\theta_3 = \theta_{ee} - \theta_1 - \theta_2$$

### Solution selection

Steps 4–6 produce two solutions (elbow-up and elbow-down). The planner selects the one with lower total joint movement relative to the current arm state — this minimizes unnecessary motion and tends to produce smoother trajectories.

---

## Trajectory Interpolation

Moving directly between joint states produces abrupt motion. The simulator uses a cubic smoothstep function to produce smooth acceleration and deceleration:

$$s(t) = 3t^2 - 2t^3, \quad t \in [0, 1]$$

Joint interpolation:

$$\theta(t) = \theta_{start} + s(t)(\theta_{target} - \theta_{start})$$

This is $C^1$ continuous — smooth velocity with zero velocity at both endpoints. The acceleration has a discontinuity at the start and end points. A proper motion profile would use a quintic polynomial or trapezoidal velocity profile, but smoothstep is sufficient for visualization.

---

## Workspace

The theoretical maximum reach:

$$r_{max} = L_1 + L_2 + L_3 = 225 \text{ mm}$$

In practice, the reachable workspace is further constrained by:
- joint angle limits (not yet enforced in the simulator)
- the deadzone (the arm's base assembly)
- the ground plane ($z \geq 0$)

The simulator visualizes the workspace boundary as a circle in top view and an arc in side view.

---

## Notes on Numerical Behavior

- The law of cosines step clamps $D$ to $[-1, 1]$. Without this, floating-point errors near singular configurations (fully extended or fully retracted arm) cause `atan2` to produce NaN.
- `atan2` is used throughout instead of `atan` because it handles all four quadrants and avoids division-by-zero at 90°.
- The wrist reachability check in step 3 is important — skipping it can produce IK solutions where the wrist point is geometrically invalid, leading to incorrect arm configurations that pass the reachability check but have physically wrong joint angles.
