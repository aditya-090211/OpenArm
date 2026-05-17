# Motion Planning & Simulation

## Overview

The OpenArm simulation environment is currently built in GNU Octave and focuses on:
- forward kinematics
- inverse kinematics
- cylindrical coordinate motion planning
- collision-aware trajectory generation
- heuristic path optimization
- 3D visualization

The simulator acts as both:
- a robotics research environment
- a development sandbox for future real-world hardware control

---

# Coordinate System

The arm currently operates using a cylindrical coordinate system.

The workflow is divided into two stages.

---

## 1. Top View

The user selects:
- movement plane
- base rotation direction

This determines the base rotation angle.

$$
\theta_{base} = atan2(y, x)
$$

---

## 2. Side View

The user selects:
- radial extension
- vertical height

This creates cylindrical target coordinates:

$$
(r, z)
$$

The simulator converts cylindrical coordinates back into Cartesian coordinates:

$$
x = r \cos(\theta_{base})
$$

$$
y = r \sin(\theta_{base})
$$

This approach was chosen because:
- it simplifies interaction
- matches the robot's kinematic structure
- separates base rotation from planar IK solving
- improves visualization and debugging

---

# Kinematics

The simulator supports:
- Forward Kinematics (FK)
- Inverse Kinematics (IK)

---

# Forward Kinematics (FK)

Forward kinematics calculates:
- joint positions
- link positions
- end effector position
- full arm geometry in 3D space

---

## Link Definitions

$$
L_1 = \text{shoulder link length}
$$

$$
L_2 = \text{elbow link length}
$$

$$
L_3 = \text{wrist/end effector link length}
$$

---

## Joint Angles

$$
\theta_1 = \text{shoulder angle}
$$

$$
\theta_2 = \text{elbow angle}
$$

$$
\theta_3 = \text{wrist angle}
$$

---

## Base Rotation

$$
\theta_{base} = \text{base rotation angle}
$$

---

## Shoulder Joint Position

The shoulder is offset from the center of the base.

$$
x_s = d_{offset} \cos(\theta_{base})
$$

$$
y_s = d_{offset} \sin(\theta_{base})
$$

$$
z_s = h_{shoulder}
$$

---

## First Link Endpoint

$$
p_{x1} = L_1 \cos(\theta_1)
$$

$$
p_{z1} = L_1 \sin(\theta_1)
$$

---

## Second Link Endpoint

$$
p_{x2} = p_{x1} + L_2 \cos(\theta_1 + \theta_2)
$$

$$
p_{z2} = p_{z1} + L_2 \sin(\theta_1 + \theta_2)
$$

---

## End Effector Position

$$
p_{x3} = p_{x2} + L_3 \cos(\theta_1 + \theta_2 + \theta_3)
$$

$$
p_{z3} = p_{z2} + L_3 \sin(\theta_1 + \theta_2 + \theta_3)
$$

---

## Conversion Into 3D Space

$$
x = x_s + p_x \cos(\theta_{base})
$$

$$
y = y_s + p_x \sin(\theta_{base})
$$

$$
z = z_s + p_z
$$

---

# Inverse Kinematics (IK)

Inverse kinematics calculates:
- shoulder angle
- elbow angle
- wrist angle

from a desired target position.

---

# Cylindrical Target Conversion

Target radial distance:

$$
r = \sqrt{x^2 + y^2}
$$

Relative target coordinates:

$$
d_x = r - d_{offset}
$$

$$
d_z = z - h_{shoulder}
$$

Distance from shoulder:

$$
d = \sqrt{d_x^2 + d_z^2}
$$

---

# End Effector Orientation

Desired arm direction:

$$
\theta_{ee} = atan2(d_z, d_x)
$$

---

# Wrist Position

The wrist joint position is calculated by subtracting the end effector length.

$$
w_x = d_x - L_3 \cos(\theta_{ee})
$$

$$
w_z = d_z - L_3 \sin(\theta_{ee})
$$

---

# Law of Cosines

The elbow angle is solved using:

$$
D =
\frac{
w_x^2 + w_z^2 - L_1^2 - L_2^2
}{
2 L_1 L_2
}
$$

Elbow angle:

$$
\theta_2 = atan2(\pm \sqrt{1-D^2}, D)
$$

This generates:
- elbow-up solution
- elbow-down solution

---

# Shoulder Angle

$$
\theta_1 =
atan2(w_z, w_x)
-
atan2(
L_2 \sin(\theta_2),
L_1 + L_2 \cos(\theta_2)
)
$$

---

# Wrist Angle

$$
\theta_3 =
\theta_{ee}
-
\theta_1
-
\theta_2
$$

---

# Trajectory Generation

Joint trajectories are interpolated smoothly between:
- current state
- target state

---

# Cubic Smoothstep Interpolation

The simulator currently uses:

$$
s(t) = 3t^2 - 2t^3
$$

This provides:
- smooth acceleration
- smooth deceleration
- reduced sudden motion

Joint interpolation:

$$
\theta(t) =
\theta_{start}
+
s(t)
(
\theta_{target}
-
\theta_{start}
)
$$

---

# Motion Planning

The current system uses a heuristic Monte Carlo-style planner.

Instead of generating only a single direct trajectory, the simulator:
- generates many candidate waypoint sets
- computes IK for each candidate
- collision-checks each trajectory
- scores each valid trajectory
- selects the lowest-cost valid solution

The planner currently evaluates:
- direct trajectories
- elevated arc trajectories
- retract-and-extend motions
- randomized intermediate waypoints
- lift-first motions
- offset approach paths

The planner typically evaluates:

$$
1000
$$

candidate trajectories per target.

---

# Collision Detection

The simulator includes:
- deadzone collision detection
- ground collision detection
- dense link sampling

Collision checks are performed continuously throughout the trajectory.

---

# Link Sampling

Each distal link is sampled densely.

$$
p(t) =
p_{start}
+
t
(
p_{end}
-
p_{start}
)
$$

where:

$$
0 \le t \le 1
$$

---

# Ground Collision

A collision occurs if:

$$
z < 0
$$

---

# Deadzone Collision

A collision occurs if all conditions are true simultaneously:

$$
x_{min} < x < x_{max}
$$

$$
y_{min} < y < y_{max}
$$

$$
z_{min} < z < z_{max}
$$

---

# Path Scoring

Valid paths are scored using:
- total joint movement
- smoothness
- collision proximity

Approximate cost function:

$$
C =
\sum
|\Delta \theta_i|
+
\lambda
\left(
\frac{1}{d_{collision}}
\right)
$$

where:
- smaller joint movement is preferred
- larger obstacle clearance is preferred

---

# Visualization

The simulator includes:
- real-time 3D animation
- cylindrical target selection
- workspace visualization
- deadzone visualization
- live trajectory playback
- joint visualization

The visualization system is primarily intended for:
- debugging
- trajectory validation
- kinematic testing
- collision debugging
- educational visualization

---

# Current Limitations

## Performance

The planner is currently relatively slow because:
- 1000 candidate paths are evaluated
- each path contains multiple trajectory segments
- collision sampling is dense
- collision checks are continuous

Planning may take several seconds depending on:
- target position
- obstacle proximity
- trajectory complexity

This is expected for the current brute-force heuristic implementation.

---

## No True Global Planner

The current system does not yet use:
- RRT
- RRT*
- PRM
- A*
- CHOMP
- OMPL
- MoveIt

Instead, it uses heuristic randomized trajectory generation.

Although this works surprisingly well for the current OpenArm geometry, it is not mathematically optimal.

---

## Limited Collision Geometry

Current collision detection only checks:
- deadzone box
- ground plane

The simulator does not yet support:
- full mesh collisions
- self-collision detection
- swept volume analysis
- dynamic obstacle avoidance
- real CAD collision geometry

---

## Simplified Dynamics

The simulator currently focuses on:
- geometry
- kinematics
- trajectory planning

and does not yet simulate:
- torque limits
- inertia
- actuator acceleration
- backlash
- structural flex
- vibration
- belt elasticity
- motor dynamics

---

# Future Development Goals

Planned future improvements include:
- self-collision detection
- spline trajectory generation
- acceleration-limited motion
- real-time replanning
- dynamic obstacle avoidance
- reinforcement learning experiments
- full CAD collision geometry
- hardware-in-the-loop simulation
- CAN bus motor integration
- encoder feedback integration
- real-world synchronization

---

# Purpose of the Simulator

The simulator is intended to:
- validate arm geometry
- test kinematic models
- prototype motion planning systems
- experiment with control algorithms
- visualize robotic behavior
- support future hardware development

before deploying algorithms onto the physical OpenArm platform.
