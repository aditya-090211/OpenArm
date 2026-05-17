# Research Notes — Kinematics, Motion Planning, and Simulation

## Overview

This document summarizes the research, experimentation, and development process behind the OpenArm simulation and motion planning system.

The goal of this phase of the project was to develop:
- a mathematically accurate kinematic model
- an interactive simulation environment
- collision-aware motion planning
- realistic trajectory generation
- a scalable software architecture

before constructing the physical robotic arm.

This research phase focused heavily on:
- robotics mathematics
- inverse kinematics
- trajectory planning
- workspace analysis
- collision detection
- visualization systems
- software architecture

---

# Why Simulation Was Developed First

The simulator was developed before hardware construction because:
- physical iteration is expensive
- design changes are frequent
- software debugging is easier in simulation
- collision issues can be found early
- kinematic mistakes can be corrected before manufacturing

The simulation environment acts as:
- a robotics sandbox
- a motion planning research platform
- a validation environment for future hardware

---

# Initial Kinematic Model

The first versions of the simulator were purely 2D.

The arm initially consisted of:
- shoulder joint
- elbow joint
- wrist joint

with fixed link lengths.

Early development focused on:
- basic forward kinematics
- endpoint positioning
- link geometry
- workspace visualization

At this stage:
- there was no collision checking
- no trajectory planning
- no base rotation
- no motion optimization

The primary goal was simply proving that the mathematical model worked.

---

# Forward Kinematics Research

Forward kinematics was implemented first because it is the foundation for:
- visualization
- animation
- collision detection
- debugging
- workspace analysis

Forward kinematics calculates the position of every joint using:
- link lengths
- joint angles

The arm geometry is solved sequentially from the base outward.

---

# Link Geometry

The arm currently uses:
- three primary joints
- three primary links

Definitions:

$$
L_1 = \text{shoulder link length}
$$

$$
L_2 = \text{elbow link length}
$$

$$
L_3 = \text{wrist link length}
$$

Joint angles:

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

# Base Rotation

The arm later evolved into a full 3D system with:
- cylindrical coordinate motion
- rotating base joint

The base rotation angle is:

$$
\theta_{base} = atan2(y, x)
$$

This separates:
- planar solving
- rotational solving

which simplifies inverse kinematics significantly.

---

# Shoulder Offset Research

One major challenge was that the shoulder motor is not centered directly above the base axis.

Instead:
- the shoulder joint is offset horizontally
- the arm sits forward relative to the base rotation axis

This required:
- custom forward kinematics
- custom cylindrical coordinate conversion
- adjusted workspace calculations

The shoulder offset is represented as:

$$
d_{offset}
$$

Shoulder position:

$$
x_s = d_{offset} \cos(\theta_{base})
$$

$$
y_s = d_{offset} \sin(\theta_{base})
$$

$$
z_s = h_{shoulder}
$$

This became one of the most important improvements because it made the simulation significantly more realistic relative to the actual CAD design.

---

# Inverse Kinematics Research

After forward kinematics was functioning correctly, inverse kinematics was implemented.

Inverse kinematics solves:
- required joint angles
- from a desired target position

This was one of the most mathematically intensive parts of the project.

---

# Cylindrical Coordinate System

The simulator currently uses a cylindrical target selection system.

Instead of selecting:
- x
- y
- z

directly, the workflow was redesigned into:
- plane selection
- radial selection
- height selection

This made interaction:
- more intuitive
- easier to debug
- closer to the actual physical robot structure

The cylindrical conversion equations are:

$$
x = r \cos(\theta_{base})
$$

$$
y = r \sin(\theta_{base})
$$

---

# Wrist Position Solving

The end effector orientation is first calculated:

$$
\theta_{ee} = atan2(d_z, d_x)
$$

Then the wrist joint position is solved by subtracting the wrist link length:

$$
w_x = d_x - L_3 \cos(\theta_{ee})
$$

$$
w_z = d_z - L_3 \sin(\theta_{ee})
$$

This converts the arm into a simpler 2-link inverse kinematics problem.

---

# Law of Cosines

The elbow angle is solved using the law of cosines.

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

This produces:
- elbow-up solutions
- elbow-down solutions

The solver then selects the solution with the lowest movement cost relative to the current arm state.

---

# Shoulder Angle

The shoulder angle is solved using:

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

The wrist angle is calculated using:

$$
\theta_3 =
\theta_{ee}
-
\theta_1
-
\theta_2
$$

---

# Transition to 3D

One major development phase was transitioning the simulator from:
- 2D planar motion
to:
- full 3D motion

This introduced:
- base rotation
- cylindrical motion planning
- 3D visualization
- spatial collision checking

This dramatically increased:
- complexity
- computational load
- collision edge cases

but made the simulator significantly more realistic.

---

# Deadzone Research

The arm contains a large base assembly consisting of:
- electronics
- motors
- belts
- structural supports

This created a "deadzone" volume that the arm should not enter.

The deadzone is modeled as a collision box.

The simulator continuously checks whether any arm segment enters this region.

This became one of the most difficult parts of development because:
- some valid trajectories clipped corners
- some trajectories intersected during interpolation
- certain poses became difficult to solve safely

---

# Collision Detection

Collision detection evolved through several iterations.

Early versions:
- only checked endpoint positions

Later versions:
- checked full trajectories
- sampled link segments densely
- checked continuous motion

Each link is sampled using:

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

This significantly improved collision accuracy.

---

# Ground Collision

Ground collision is handled using:

$$
z < 0
$$

This prevents the arm from moving below the ground plane.

Early versions frequently produced:
- underground trajectories
- invalid elbow configurations

which required additional constraints.

---

# Heuristic Motion Planning

One of the largest research areas became motion planning.

A direct IK solution is often not sufficient because:
- the arm may collide during motion
- intermediate states may be invalid
- some trajectories are inefficient

Instead of using a direct trajectory, the planner:
- generates many candidate waypoint sets
- computes trajectories for each
- collision checks them
- scores them
- selects the best valid solution

The planner currently evaluates approximately:

$$
1000
$$

candidate trajectories per target.

---

# Monte Carlo Style Planning

The planner behaves similarly to a heuristic Monte Carlo search.

It tests:
- direct paths
- elevated arcs
- retract-and-extend motions
- randomized intermediate waypoints
- lift-first trajectories
- offset approach paths

This dramatically improved:
- reliability
- obstacle avoidance
- path quality

although it increased computation time significantly.

---

# Trajectory Interpolation

The simulator uses smooth interpolation instead of direct angle jumps.

The current interpolation function is:

$$
s(t) = 3t^2 - 2t^3
$$

This creates:
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

# Path Scoring

Each valid trajectory is scored based on:
- total joint movement
- smoothness
- obstacle clearance

Approximate scoring function:

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

This encourages:
- smaller motion
- smoother movement
- safer trajectories

---

# Visualization System

The visualization system evolved significantly throughout development.

The simulator currently includes:
- top-view target selection
- side-view radial selection
- live 3D animation
- deadzone rendering
- workspace rendering
- trajectory playback
- joint visualization

The visualization system became extremely important for:
- debugging
- validating IK
- understanding collisions
- tuning trajectories

Many major bugs were discovered visually rather than mathematically.

---

# Major Problems Encountered

## Invalid Workspace Detection
Some targets were incorrectly marked as unreachable even though they were clearly inside the workspace.

This was caused by:
- poor wrist positioning
- incorrect orientation assumptions
- singular edge cases

---

## Ground Penetration
Early versions frequently drove the arm below the ground plane.

This required:
- trajectory constraints
- continuous collision checking
- additional IK filtering

---

## Deadzone Clipping
Some trajectories clipped through corners of the deadzone during interpolation.

This required:
- denser sampling
- continuous collision testing
- safer waypoint generation

---

## Performance Problems
The planner became increasingly slow as:
- collision density increased
- candidate count increased
- trajectory complexity increased

The current planner is computationally expensive because it brute-forces many possible trajectories.

However, this approach was chosen because:
- it is flexible
- easy to modify
- effective for experimentation

---

# Current Limitations

The simulator still does not include:
- full rigid body dynamics
- motor torque simulation
- acceleration constraints
- real-time replanning
- self-collision detection
- CAD mesh collision
- actuator modeling
- encoder feedback
- hardware synchronization

The current focus remains:
- kinematics
- motion planning
- software architecture
- visualization
- research experimentation

---

# Future Research Areas

Future planned research includes:
- PID control
- motion profiling
- acceleration-limited trajectories
- spline interpolation
- self-collision systems
- reinforcement learning
- real-time planning
- hardware-in-the-loop simulation
- computer vision
- autonomous grasping
- dynamic obstacle avoidance

---

# Purpose of This Research

This research phase was intended to:
- validate arm geometry
- test mathematical models
- prototype motion planning systems
- experiment with robotics algorithms
- understand robotic arm behavior
- create a scalable software foundation

before deploying algorithms onto the physical OpenArm platform.
