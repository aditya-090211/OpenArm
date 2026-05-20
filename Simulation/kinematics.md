# Simulation — Kinematics Reference

Technical reference for the kinematic model implemented in `openarm_ik.m`. Covers the coordinate system, FK equations, IK derivation, and trajectory interpolation.

For a higher-level description of how the motion planner and collision system work, see `Simulation/README.md`. For deeper context on the math, see `Research/kinematics_reference.md`.

---

## Coordinate System

The arm operates in a cylindrical coordinate system. Target selection uses a two-step workflow:

**Top view** — selects base rotation angle:

$$\theta_{base} = \text{atan2}(y, x)$$

**Side view** — selects radial distance $r$ and height $z$, then converts:

$$x_t = r \cos(\theta_{base}), \quad y_t = r \sin(\theta_{base})$$

This separates base rotation from the 2D planar IK problem, simplifying both the solver and the interaction.

---

## Arm Parameters (Current Design)

| Parameter | Value |
|---|---|
| L1 (shoulder to elbow) | 75 mm |
| L2 (elbow to wrist) | 75 mm |
| L3 (wrist to end effector) | 75 mm |
| Shoulder offset from base axis | 31.64 mm |
| Shoulder height | 55 mm |
| Maximum reach | 225 mm |

---

## Forward Kinematics

Shoulder position (accounts for base rotation and horizontal offset):

$$x_s = d_{offset} \cos(\theta_{base}), \quad y_s = d_{offset} \sin(\theta_{base}), \quad z_s = h_{shoulder}$$

In the arm's local planar frame:

**Elbow:**

$$p_{x1} = L_1 \cos(\theta_1), \quad p_{z1} = L_1 \sin(\theta_1)$$

**Wrist:**

$$p_{x2} = p_{x1} + L_2 \cos(\theta_1 + \theta_2), \quad p_{z2} = p_{z1} + L_2 \sin(\theta_1 + \theta_2)$$

**End effector:**

$$p_{x3} = p_{x2} + L_3 \cos(\theta_1 + \theta_2 + \theta_3), \quad p_{z3} = p_{z2} + L_3 \sin(\theta_1 + \theta_2 + \theta_3)$$

Converting to 3D Cartesian:

$$x = x_s + p_x \cos(\theta_{base}), \quad y = y_s + p_x \sin(\theta_{base}), \quad z = z_s + p_z$$

---

## Inverse Kinematics

**Step 1 — Shoulder-relative target:**

$$d_x = r - d_{offset}, \quad d_z = z_t - h_{shoulder}$$

**Step 2 — End effector orientation:**

$$\theta_{ee} = \text{atan2}(d_z, d_x)$$

**Step 3 — Wrist position:**

$$w_x = d_x - L_3 \cos(\theta_{ee}), \quad w_z = d_z - L_3 \sin(\theta_{ee})$$

**Step 4 — Elbow angle (law of cosines):**

$$D = \frac{w_x^2 + w_z^2 - L_1^2 - L_2^2}{2 L_1 L_2}, \quad D = \text{clamp}(D, -1, 1)$$

$$\theta_2 = \text{atan2}\left(\pm\sqrt{1 - D^2},\ D\right)$$

**Step 5 — Shoulder angle:**

$$\theta_1 = \text{atan2}(w_z, w_x) - \text{atan2}\left(L_2 \sin(\theta_2),\ L_1 + L_2 \cos(\theta_2)\right)$$

**Step 6 — Wrist angle:**

$$\theta_3 = \theta_{ee} - \theta_1 - \theta_2$$

Both elbow-up and elbow-down solutions are evaluated. The solver selects the one with lower total joint movement from the current state.

---

## Trajectory Interpolation

Cubic smoothstep:

$$s(t) = 3t^2 - 2t^3, \quad t \in [0, 1]$$

$$\theta(t) = \theta_{start} + s(t)\left(\theta_{target} - \theta_{start}\right)$$

$C^1$ continuous — smooth velocity, zero velocity at endpoints. 45 steps per trajectory segment.

---

## Deadzone Collision Model

Axis-aligned bounding box representing the base assembly (180mm × 100mm × 57mm, plus 8mm safety margin on all faces).

A point collides with the deadzone if all three conditions hold simultaneously:

$$x_{min} < x < x_{max}, \quad y_{min} < y < y_{max}, \quad z_{min} < z < z_{max}$$

Ground collision: $z < 0$.

Each distal link sampled at 25 points per segment at every trajectory step:

$$p(t) = p_{start} + t(p_{end} - p_{start}), \quad t \in [0, 1]$$

---

## Path Scoring

$$C = \sum_{i} |\Delta\theta_i| + 0.02 \cdot \frac{1}{\max(d_{collision}, 1)}$$

where $d_{collision}$ is minimum distance from any sampled point to the nearest collision boundary. Lower cost is preferred.
