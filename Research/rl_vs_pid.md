# RL vs PID — Control Strategy Tradeoffs for Low-Cost Robotics

One of the questions that's been driving a lot of the OpenArm design decisions: **how much does hardware quality actually matter if you're willing to invest in the control system?**

This document explores the engineering tradeoffs between PID control, reinforcement learning, hardware precision, and accessibility — specifically in the context of a low-cost manipulator designed for education and light research.

---

## The Central Question

Industrial robotic arms justify expensive hardware — precision gearboxes, high-resolution encoders, rigid structures — partly because their controllers assume hardware repeatability. The control algorithm expects the motor to go where it's told, and compensates for small errors in tightly bounded ways.

Modern robot learning approaches work differently. An RL policy can, in principle, learn to compensate for hardware imperfections by observing outcomes and adjusting behavior. If this compensation is effective, it changes the hardware cost calculus: maybe you don't need a 100:1 harmonic drive if your controller can learn to handle backlash. Maybe cheap magnetic encoders are fine if the learning system accounts for their noise.

This isn't a proven claim — it's a hypothesis worth testing experimentally. OpenArm is partly motivated by wanting to know where this tradeoff actually lands for small, cheap manipulators.

---

## What PID Actually Does Well

PID (and its variants — cascade PID, PD with gravity compensation, feedforward terms) is well-understood, predictable, and proven. For a well-built arm with good encoders and low backlash, a properly tuned PID controller can achieve excellent repeatability and positioning accuracy.

The main requirements for PID to work well:
- **Consistent mechanical behavior.** PID assumes the plant is approximately linear and time-invariant around the operating point. A joint with a lot of backlash, varying friction, or significant flex violates these assumptions.
- **Good encoder feedback.** PID is only as good as its sensors. An AS5600 (12-bit, 4096 counts/rev) gives 0.088° resolution before gearing, which becomes approximately 0.013° after a 7:1 reduction — probably adequate for this arm's geometry.
- **Bandwidth.** The controller update rate needs to be fast relative to the mechanical dynamics. CAN bus at 1 Mbit/s can support update rates well above the mechanical bandwidth of this arm.

For a well-made version of OpenArm with decent encoders, PID is probably the right first control approach. It's predictable, tunable, and doesn't require any training data.

---

## Where RL Becomes Interesting

RL starts to look more compelling in cases where the hardware behaves in ways that are hard to model:

- **Structural flex.** If the arm flexes under load, the actual end effector position differs from what the joint angles predict. PID on joint angles can't see this error. A vision-based RL policy could, in principle, learn to compensate.
- **Variable friction.** Belt tension, motor cogging, and temperature-dependent friction create nonlinearities that are annoying to model. An RL policy can learn empirical behaviors that implicitly account for these without needing an explicit model.
- **Backlash.** A 1–2° backlash at the elbow creates roughly 2–5mm of end effector uncertainty at 150mm reach. This is hard to compensate with joint-level PID because the encoder can't distinguish which side of the backlash the load is on.

The argument isn't that RL is better than PID — it's that RL might allow cheaper hardware to achieve similar task performance by compensating for hardware imperfections that PID struggles with.

---

## Honest Problems with RL on Real Hardware

RL is not magic. Training on real robotics hardware has well-known problems:

**Sample efficiency.** Most RL algorithms require many thousands of interactions to learn a useful policy. On a real robot, this means hours or days of unsupervised operation, which is wear on hardware and a safety issue. Sim-to-real transfer helps but introduces its own problems.

**Sim-to-real gap.** A policy trained in simulation often fails on real hardware because the simulation doesn't accurately capture friction, backlash, motor dynamics, or sensor noise. Closing this gap requires careful system identification — which requires the kind of hardware testing we haven't done yet.

**Safety constraints.** A random exploration policy on a real arm will hit joint limits, collide with things, and potentially damage hardware. Safe RL (reward shaping, action constraints, conservative initialization) adds significant complexity.

**Repeatability under distribution shift.** An RL policy trained on one configuration of the arm (specific cable tension, specific temperature) may behave differently when those conditions change. A well-tuned PID controller degrades more predictably.

**Compute limitations.** Training a useful policy for real hardware requires non-trivial compute. Inference is cheap, but training on-device on a Raspberry Pi is not realistic.

---

## Practical Implications for OpenArm

For the first prototype, the plan is:

1. Start with open-loop stepping to validate kinematics (simplest possible)
2. Add closed-loop PID once encoders are integrated (standard approach)
3. Characterize actual hardware imperfections through testing (backlash, flex, friction)
4. Evaluate whether PID performance is adequate for intended use cases
5. If not, investigate whether RL or adaptive control provides meaningful improvement

The RL question is genuinely interesting but probably premature until there's real hardware to experiment on. Simulated RL on the current Octave model would tell us very little about whether it works in practice.

---

## The Hardware Precision Question

One specific version of this question that OpenArm is well-positioned to explore: **what's the actual performance difference between a ₹15,000 arm and a ₹50,000 arm?**

The current BOM is ~₹50,000, primarily because of the CAN bus stepper modules. If we replaced those with simpler stepper drivers and kept the rest, the cost drops significantly. The hardware becomes less integrated and slightly harder to program, but the mechanical performance might not be dramatically different.

Testing this comparison — same geometry, different actuator quality, same control algorithm — would produce useful data about where cost reduction actually hurts performance.

---

## What This Project Is Not Claiming

To be clear about the scope:

- This project is **not** doing RL research. It's building hardware and simulation infrastructure that could eventually support RL experiments.
- **RL is not assumed to solve the cost problem.** It's a hypothesis worth testing, not a given.
- The project is not claiming that cheap hardware + RL = industrial arm performance. The question is whether cheap hardware + good software can achieve performance adequate for educational and research use cases.
- Any actual RL experiments are future work, contingent on having a working physical prototype.
