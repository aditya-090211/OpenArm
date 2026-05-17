# OpenArm Mathematics — Beginner Friendly Guide

## Introduction

This document explains the mathematical concepts used in the OpenArm robotic arm project in a way that is understandable even without advanced math knowledge.

You do NOT need university-level math to start robotics.

Most beginner robotics is built using:
- geometry
- triangles
- basic trigonometry
- logical thinking

The goal of this document is to explain:
- what the math means
- why it exists
- how it is used in the robot

---

# What Is Kinematics?

Kinematics is the study of:
# how things move

without worrying about:
- forces
- weight
- motors
- torque

In robotics, kinematics is mainly about:
- where the robot arm is
- where it can move
- what angles the joints should rotate to

Robot kinematics studies the relationship between joint motion and the robot’s final position. :contentReference[oaicite:0]{index=0}

---

# What Is a Robotic Arm?

A robotic arm is basically:
- multiple rigid bars
- connected by rotating joints

Like a human arm:
- shoulder
- elbow
- wrist

Each section is called a:
# link

Each rotating point is called a:
# joint

---

# Degrees of Freedom (DOF)

A degree of freedom means:
# one independent movement

Example:
- one rotating joint = 1 DOF
- one slider = 1 DOF

Your arm currently has:
- base rotation
- shoulder joint
- elbow joint
- wrist joint

So it has:
# 4 degrees of freedom

---

# Coordinate Systems

Robots need a way to describe positions in space.

The most common system is:
# Cartesian coordinates

This uses:
- X
- Y
- Z

Example:

```txt
X = left/right
Y = forward/backward
Z = up/down
```

---

# Cylindrical Coordinates

Your robot uses:
# cylindrical coordinates

because the base rotates.

Instead of:
- X
- Y
- Z

you use:
- radius
- angle
- height

Think of it like:
- spinning around
- reaching outward
- moving upward

---

# Base Rotation

The base angle determines which direction the arm faces.

The equation used is:

$$ \theta_{base} = atan2(y, x) $$

This calculates:
# the angle between the target and the X-axis

---

# What Is atan2?

`atan2()` is a math function that calculates angles.

Normal tangent only works sometimes.

`atan2()` is smarter because it:
- knows the correct direction
- works in all quadrants
- handles negative coordinates properly

This is heavily used in robotics. :contentReference[oaicite:1]{index=1}

---

# Link Lengths

Each arm segment has a length.

Example:

$$ L_1 = 75mm $$

$$ L_2 = 75mm $$

$$ L_3 = 75mm $$

These lengths are extremely important because they define:
- maximum reach
- workspace
- geometry

---

# What Is Forward Kinematics?

Forward kinematics means:

# "If I know the joint angles, where is the arm?"

You already know:
- shoulder angle
- elbow angle
- wrist angle

The computer calculates:
- end effector position

Forward kinematics computes end-effector position from joint values. :contentReference[oaicite:2]{index=2}

---

# Trigonometry Basics

Robotic arms heavily use:
- sine
- cosine

These functions come from triangles.

---

# Cosine

Cosine helps calculate:
# horizontal distance

Example:

$$ x = L \cos(\theta) $$

Meaning:
- take the length
- multiply by cosine
- get horizontal movement

---

# Sine

Sine helps calculate:
# vertical distance

Example:

$$ z = L \sin(\theta) $$

Meaning:
- take the length
- multiply by sine
- get vertical movement

---

# First Link Position

The first arm segment position is:

$$ p_{x1} = L_1 \cos(\theta_1) $$

$$ p_{z1} = L_1 \sin(\theta_1) $$

This calculates where the elbow is located.

---

# Second Link Position

The second link adds onto the first one.

$$ p_{x2} = p_{x1} + L_2 \cos(\theta_1 + \theta_2) $$

$$ p_{z2} = p_{z1} + L_2 \sin(\theta_1 + \theta_2) $$

This calculates where the wrist is located.

---

# End Effector Position

The end effector is the tool at the end of the arm.

Example:
- gripper
- claw
- suction cup

Its position is:

$$ p_{x3} = p_{x2} + L_3 \cos(\theta_1 + \theta_2 + \theta_3) $$

$$ p_{z3} = p_{z2} + L_3 \sin(\theta_1 + \theta_2 + \theta_3) $$

---

# What Is Inverse Kinematics?

Inverse kinematics means:

# "I know where I want the arm to go. What angles do I need?"

This is much harder than forward kinematics.

Inverse kinematics calculates joint values from a desired target position. :contentReference[oaicite:3]{index=3}

---

# Why IK Is Difficult

Because:
- many angles can reach the same point
- some positions are impossible
- some positions cause collisions

The robot must figure out:
- the best solution
- the safest solution
- the smoothest solution

---

# Distance Formula

The robot first calculates how far away the target is.

This uses the Pythagorean theorem:


::contentReference[oaicite:4]{index=4}


Distance equation:

$$ d = \sqrt{x^2 + z^2} $$

This calculates straight-line distance.

---

# Wrist Position

The robot does not solve IK directly for the end effector.

Instead:
- it first finds the wrist position
- then solves a simpler triangle

Wrist equations:

$$ w_x = d_x - L_3 \cos(\theta_{ee}) $$

$$ w_z = d_z - L_3 \sin(\theta_{ee}) $$

---

# Law of Cosines

The elbow angle is solved using:
# the law of cosines

This is one of the most important robotics equations.

$$ D = \frac{w_x^2 + w_z^2 - L_1^2 - L_2^2}{2L_1L_2} $$

Then:

$$ \theta_2 = atan2(\pm\sqrt{1-D^2}, D) $$

This gives:
- elbow-up solution
- elbow-down solution

---

# Shoulder Angle

The shoulder angle is:

$$ \theta_1 = atan2(w_z, w_x) - atan2(L_2\sin(\theta_2), L_1 + L_2\cos(\theta_2)) $$

This determines how high the shoulder rotates.

---

# Wrist Angle

The wrist angle is:

$$ \theta_3 = \theta_{ee} - \theta_1 - \theta_2 $$

This keeps the end effector facing correctly.

---

# Workspace

The workspace is:
# everywhere the arm can reach

Every robotic arm has limits.

The arm cannot:
- stretch infinitely
- bend through itself
- go underground

---

# Collision Detection

The simulator checks whether:
- the arm hits the ground
- the arm enters the deadzone

A collision happens if:

$$ z < 0 $$

meaning:
# below the ground

---

# Deadzone

The deadzone is the robot’s base area.

It contains:
- motors
- belts
- electronics
- structural parts

The arm should avoid entering this space.

---

# Sampling

The simulator checks many points along each arm segment.

Equation:

$$ p(t) = p_{start} + t(p_{end} - p_{start}) $$

where:

$$ 0 \le t \le 1 $$

This creates many test points along the link.

---

# Motion Planning

The robot does not simply move directly to the target.

Instead it:
- tries many possible paths
- checks collisions
- scores trajectories
- selects the best one

This is called:
# motion planning

Robot motion planning is a major field within robotics kinematics. :contentReference[oaicite:5]{index=5}

---

# Monte Carlo Style Planning

Your planner behaves somewhat like:
# a Monte Carlo search

It:
- generates random possible paths
- tests them
- keeps the best valid solution

The simulator currently checks about:

$$ 1000 $$

possible trajectories.

---

# Smooth Motion

Robots should not instantly jump between angles.

Instead:
- motion should accelerate smoothly
- motion should slow down smoothly

The simulator uses:

$$ s(t) = 3t^2 - 2t^3 $$

This creates smoother movement.

---

# Path Scoring

The simulator scores paths using:
- movement amount
- collision distance
- smoothness

Approximate scoring equation:

$$ C = \sum |\Delta\theta_i| + \lambda \left(\frac{1}{d_{collision}}\right) $$

Meaning:
- less movement is better
- staying farther from obstacles is better

---

# Why the Simulator Is Slow

The simulator is computationally expensive because:
- 1000 paths are tested
- every path checks collisions
- every link is sampled many times
- inverse kinematics runs repeatedly

This is normal for brute-force robotics planning.

---

# What This Math Actually Means

At first robotics math looks difficult.

But most beginner robotic arms mainly use:
- triangles
- geometry
- sine
- cosine
- angles
- distance formulas

The hardest part is usually:
# understanding how all the equations connect together

not the individual equations themselves.

---

# Important Realization

Robotics is NOT just:
- coding
- CAD
- electronics

It is mainly:
# applied mathematics

The math tells the robot:
- where it is
- where it can move
- how it should move
- how to avoid collisions

Without the math:
the robot is just motors and metal.

---

# Final Notes

The OpenArm simulation was designed to:
- learn robotics mathematics
- experiment with motion planning
- prototype algorithms
- validate arm geometry
- prepare for real-world hardware

before constructing the physical robotic arm platform.
