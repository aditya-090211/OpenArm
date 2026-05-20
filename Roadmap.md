# Roadmap

Current thinking on where this project is going. This will change as hardware testing reveals what actually matters.

---

## Immediate Priorities

**1. First physical prototype**

The simulation is ahead of the hardware. Before investing in the full CAN bus stepper architecture, build a cheaper testbed using printed parts and standard servos/steppers to validate:
- CAD-to-reality fit
- Joint stiffness and flex
- Belt tension and backlash
- Whether the kinematic model matches real behavior

See `Research/test_plan.md` for the detailed test protocol.

**2. BOM cost reduction**

The current BOM (~₹50,000) is too high for the project's accessibility goals. The most impactful change is replacing the CAN bus stepper modules with standard NEMA17 motors + separate drivers + encoders. See `BOM.md` for the full analysis. Target: ~₹15,000–20,000.

**3. Encoder integration and closed-loop control**

The simulation runs open-loop (joint angle commands with no feedback). The hardware needs encoder integration (likely AMS AS5600 or AS5047D magnetic encoders) and a basic PID position controller before any meaningful hardware testing is possible.

---

## Medium Term

**Simulation improvements:**
- Self-collision detection (capsule approximations for each link)
- Acceleration-limited trajectory profiles (trapezoidal or S-curve velocity)
- Joint angle limit enforcement
- Spline-based path generation

**Hardware development:**
- Single-joint testbed (motor + belt + bearing + encoder)
- CAN communication firmware
- Multi-joint assembly and testing
- Payload testing and backlash measurement

**Control systems:**
- PID position control with encoder feedback
- Gravity compensation
- Characterize actual hardware imperfections (flex, backlash, friction)
- Evaluate whether PID performance is adequate for intended use cases

---

## Longer Term

**RL and adaptive control experiments** (see `Research/rl_vs_pid.md`):
- Characterize hardware imperfections quantitatively
- Build a dynamics model from hardware test data
- Evaluate sim-to-real gap
- Run controlled comparison: PID vs. adaptive control on same hardware
- Determine whether RL provides meaningful improvement over PID for this cost class of hardware

**Open-source release:**
- CAD files downloadable in step/IGES/STL
- Assembly documentation
- Bill of materials with supplier links (India-specific sourcing)
- Control software stack
- Educational resources

**Cost-optimized v2 design:**
- Target: ~₹15,000–20,000 complete
- 4-DOF maintained
- Simplified wiring
- Easier assembly
- Modular motor/driver selection

---

## What This Project Is Not

Not trying to build an industrial arm, a commercial product, or a research platform that competes with systems costing orders of magnitude more. The goal is something that a motivated high school student or a small school can actually build, understand, and learn from.

If the project succeeds, it should be useful as:
- A teaching tool for kinematics and control systems
- A research platform for studying control algorithm tradeoffs on cheap hardware
- A starting point for builders who want to understand robotic manipulation from first principles
