# OpenArm Torque Calculations & Actuator Feasibility Analysis

## Overview

This document contains ongoing torque calculations, weight analysis, and actuator feasibility studies for OpenArm.

The purpose of this document is to:
- estimate required joint torque
- validate actuator selection
- analyze mass distribution
- guide future mechanical revisions
- estimate future performance limitations
- understand the tradeoffs between weight, stiffness, and motion performance

This document is intended to evolve continuously throughout development as more testing and prototyping is completed.

---

# Current OpenArm Architecture

## Current Design Direction

The current OpenArm architecture is focused on:
- lightweight construction
- compact actuator packaging
- direct-drive joint architecture
- low backlash
- modularity
- educational accessibility
- manufacturability

The arm currently uses:
- NEMA17 stepper motors
- CANBUS-Stepper control architecture
- encoder-supported closed-loop control
- direct-drive joints
- bearing-supported joints
- aluminum-reinforced structural members
- 3D printed structural interfaces

---

# Why Torque Calculations Matter

Torque calculations are critical because robotic arms are highly affected by:
- compounded distal mass
- leverage
- acceleration loads
- structural flex
- dynamic instability

Even relatively small masses become difficult to control once placed further from the pivot point due to leverage effects.

Proper torque estimation helps:
- determine whether a motor is sufficient
- estimate future payload capability
- estimate acceleration limits
- identify possible structural weaknesses
- avoid skipped steps or instability
- guide future actuator decisions

---

# Current Mechanical Assumptions

## Current Joint Layout

The current arm geometry being analyzed:

| Parameter | Value |
|---|---|
| First segment length | 75 mm |
| Second segment length | 75 mm |
| Total reach analyzed | 150 mm |

---

# Current Mass Estimates

## Estimated Joint Mass

Each joint currently has an estimated mass of:
```txt
~170 g
```

This estimate includes:
- stepper motor
- CANBUS electronics
- bearings
- pulleys
- hardware
- printed mounting structures

The current design philosophy prioritizes:
- compactness
- low mass
- reduced inertia
- simplified assembly

---

# Structural Material Assumptions

The current structure uses:
- 3 mm aluminum reinforcement
- PETG / PETG-CF printed components

Current aluminum profile assumptions:
- approximately 24 mm wide
- lightweight structural reinforcement
- designed to improve stiffness while minimizing mass

The current design attempts to balance:
- stiffness
- manufacturability
- low cost
- educational accessibility

---

# Why Lightweight Design Is Important

In robotic arms:
- every distal gram compounds upstream torque requirements
- heavier wrist sections dramatically increase shoulder torque requirements
- increased mass increases vibration and inertia
- increased inertia reduces responsiveness and smoothness

Reducing mass provides several benefits:
- smoother motion
- reduced motor load
- lower power consumption
- improved acceleration
- lower structural stress
- reduced resonance

The current OpenArm architecture intentionally prioritizes lightweight structures to reduce these effects.

---

# Shoulder Joint Torque Analysis

## Current Configuration

The shoulder joint currently supports:
- the second arm segment
- the elbow joint
- the wrist system
- distal structure mass

This makes the shoulder one of the highest-stress joints in the system.

---

# Torque Equation

The basic torque equation used:

:contentReference[oaicite:0]{index=0}

Where:
- τ = torque
- r = distance from pivot
- F = force due to gravity

---

# First Segment Analysis

## Parameters

| Parameter | Value |
|---|---|
| Mass | 170 g |
| Distance from pivot | 37.5 mm |

---

# Force Calculation

Converting mass into force:

:contentReference[oaicite:1]{index=1}

\[
0.17 \times 9.81 \approx 1.67N
\]

---

# First Segment Torque

\[
1.67 \times 0.0375 \approx 0.063Nm
\]

Estimated first segment torque:
```txt
~0.063 Nm
```

---

# Second Segment Analysis

## Parameters

| Parameter | Value |
|---|---|
| Mass | 170 g |
| Distance from pivot | 112.5 mm |

---

# Force Calculation

\[
0.17 \times 9.81 \approx 1.67N
\]

---

# Second Segment Torque

\[
1.67 \times 0.1125 \approx 0.188Nm
\]

Estimated second segment torque:
```txt
~0.188 Nm
```

---

# Total Estimated Static Torque

## Combined Torque

\[
0.063 + 0.188 \approx 0.251Nm
\]

Estimated total static holding torque:
```txt
~0.25 Nm
```

---

# NEMA17 Feasibility Analysis

## Typical NEMA17 Torque Range

Typical standard NEMA17 motors provide approximately:
```txt
~0.4–0.6 Nm holding torque
```

Some higher-performance variants can exceed this range.

---

# Current Feasibility Conclusion

Based on the current estimates:
- a standard NEMA17 should theoretically be capable of statically holding the arm
- current lightweight architecture appears mechanically feasible
- direct-drive architecture appears realistic for early prototypes

---

# Why Static Torque Is NOT Enough

Static holding torque alone is not sufficient for real robotic systems.

Real-world robotics introduces:
- acceleration loads
- inertia
- vibration
- resonance
- motion instability
- transient torque spikes
- structural flex

Because of this, real robotic systems typically require:
```txt
2–3× safety margin
```

The current estimated desirable torque margin is:
```txt
~0.5–0.8 Nm available torque
```

This provides:
- smoother acceleration
- improved stability
- reduced skipped-step risk
- lower thermal stress
- improved responsiveness

---

# Importance of Encoder Feedback

The current architecture includes:
- encoder-supported closed-loop control

This provides major advantages compared to traditional open-loop stepper systems.

Potential benefits include:
- reduced skipped-step risk
- improved repeatability
- smoother low-speed motion
- position correction
- improved trajectory control

The encoder system is expected to significantly improve:
- motion quality
- repeatability
- overall reliability

---

# Direct-Drive Tradeoffs

The current OpenArm architecture uses:
```txt
Direct-drive joints
```

Advantages:
- reduced backlash
- simpler mechanics
- smoother motion
- easier maintenance
- quieter operation

Disadvantages:
- lower torque multiplication
- increased motor load
- greater sensitivity to structural flex
- increased importance of lightweight design

Because no large gear reduction is currently planned, minimizing mass becomes extremely important.

---

# Current Expected Limitations

The current likely limitations include:
- structural flex
- vibration
- resonance
- limited payload capability
- dynamic instability at high acceleration

The arm is currently optimized more toward:
- lightweight manipulation
- educational use
- research experimentation
- smooth low-load motion

rather than:
- industrial payload handling

---

# Structural Concerns

The largest expected mechanical challenges are likely:
- shoulder flex
- elbow torsion
- bearing alignment
- motor mount rigidity

Even small amounts of flex can compound across the arm and reduce:
- repeatability
- smoothness
- end-effector accuracy

Improving stiffness without dramatically increasing mass will be one of the primary long-term engineering challenges.

---

# Future Improvements Being Considered

Potential future improvements:
- carbon fiber reinforcement
- PETG-CF or Nylon-CF structural parts
- dual-bearing support systems
- improved calibration systems
- advanced trajectory smoothing
- dynamic motion compensation
- gravity compensation
- improved motion planning

---

# Current Development Philosophy

The current development strategy prioritizes:
- learning through iteration
- manufacturability
- affordability
- modularity
- open-source accessibility
- educational value

The project intentionally focuses on:
- practical experimentation
- engineering iteration
- continuous refinement

rather than attempting to immediately achieve industrial-grade performance.

---

# Future Work

Planned future analysis includes:
- payload capability analysis
- acceleration analysis
- dynamic torque modeling
- inertia estimation
- resonance analysis
- repeatability testing
- motion smoothing evaluation
- structural stiffness testing
- thermal analysis
- power consumption analysis

---

# Current Conclusion

The current lightweight direct-drive architecture appears mechanically feasible using standard NEMA17 motors for early OpenArm prototypes.

The current estimates suggest:
- standard NEMA17 motors should theoretically be capable of supporting the current lightweight structure
- the current design direction appears reasonable for educational and research-focused robotics
- maintaining low mass will remain critical for future performance

Further prototyping and testing will ultimately determine:
- real-world motion quality
- repeatability
- stiffness
- smoothness
- long-term reliability
- practical payload limits

This document will continue evolving as OpenArm development progresses.
