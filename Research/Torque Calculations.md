# OpenArm Torque Calculations & Actuator Feasibility Analysis

## Overview

This document contains ongoing torque calculations, weight analysis, and actuator feasibility studies for OpenArm.

The purpose of this document is to:
- estimate required joint torque
- validate actuator selection
- analyze weight distribution
- guide future mechanical revisions
- estimate future performance limitations
- understand tradeoffs between weight, stiffness, and motion quality

This document is expected to evolve continuously throughout development as more testing and prototyping is completed.

---

# Current OpenArm Architecture

## Current Design Philosophy

The current OpenArm architecture prioritizes:
- lightweight construction
- compact actuator packaging
- direct-drive joint architecture
- low backlash
- modularity
- educational accessibility
- manufacturability

The current system uses:
- NEMA17 stepper motors
- CANBUS-Stepper controller architecture
- encoder-supported closed-loop control
- direct-drive joints
- bearing-supported joints
- aluminum-reinforced structures
- 3D printed structural interfaces

---

# Why Torque Calculations Matter

Torque calculations are extremely important in robotic arms because:
- every distal gram compounds upstream torque requirements
- leverage amplifies loads dramatically
- dynamic motion increases motor demand
- structural flex reduces precision and repeatability

Even lightweight robotic systems can quickly become difficult to control if the mass distribution is poor.

Proper torque estimation helps:
- validate actuator selection
- estimate future payload capability
- estimate acceleration limits
- identify structural weaknesses
- reduce skipped-step risk
- guide future mechanical revisions

---

# Current Mechanical Assumptions

## Current Arm Geometry

Current geometry being analyzed:

| Parameter | Value |
|---|---|
| First segment length | 75 mm |
| Second segment length | 75 mm |
| Total analyzed reach | 150 mm |

---

# Current Mass Estimates

## Current Estimated Arm Mass

The current estimated moving arm mass is:
```txt
~340 g total
```

This mass includes:
- motors
- bearings
- CANBUS electronics
- pulleys
- structural components
- hardware

The current architecture intentionally prioritizes:
- low mass
- reduced inertia
- smoother motion
- reduced motor loading

---

# Important Clarification About Mass Distribution

The current 340 g estimate is NOT concentrated entirely at the end of the arm.

Instead:
- the mass is distributed approximately across the full arm length
- the structure is relatively lightweight and evenly distributed
- the center of mass is therefore significantly closer to the shoulder pivot

This dramatically reduces required shoulder torque compared to a fully distal-loaded design.

---

# Why Lightweight Design Is Critical

Lightweight robotic arms provide several major advantages:
- lower motor torque requirements
- improved acceleration
- smoother motion
- reduced vibration
- lower structural stress
- reduced resonance
- lower power consumption

In direct-drive robotic systems, minimizing distal mass is especially important because there is little or no gear reduction multiplying torque.

---

# Shoulder Joint Torque Analysis

## Current Assumptions

Current assumptions:
- total moving arm mass: ~340 g
- total arm reach: 150 mm
- mass approximately distributed across the structure

Assuming a roughly distributed mass:
- estimated center of mass ≈ 75 mm from the shoulder pivot

---

# Torque Equation

The basic torque equation used:

:contentReference[oaicite:0]{index=0}

Where:
- τ = torque
- r = distance from pivot
- F = force due to gravity

---

# Force Calculation

Force due to gravity:

:contentReference[oaicite:1]{index=1}

\[
0.34 \times 9.81
\approx 3.34N
\]

Estimated total force:
```txt
~3.34 N
```

---

# Torque Calculation

Using:
- center of mass ≈ 75 mm
- force ≈ 3.34 N

\[
3.34 \times 0.075
\approx 0.251Nm
\]

Estimated shoulder torque:
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
- a standard NEMA17 should theoretically be capable of statically holding the current arm structure
- the lightweight direct-drive architecture appears mechanically feasible
- the current torque requirements appear reasonable for an educational/research-focused robotic arm

---

# Why Static Holding Torque Is NOT Enough

Static holding torque alone does not fully represent real robotic motion requirements.

Real robotic systems also experience:
- acceleration loads
- inertia
- resonance
- vibration
- transient torque spikes
- dynamic instability

Because of this, real systems generally require:
```txt
2–3× safety margin
```

This improves:
- smoothness
- stability
- reliability
- acceleration capability
- thermal performance

The current target torque margin is approximately:
```txt
~0.5–0.8 Nm available torque
```

---

# Importance of Encoder Feedback

The current architecture includes:
- encoder-supported closed-loop control

Compared to traditional open-loop stepper systems, this provides several advantages:
- reduced skipped-step risk
- improved repeatability
- smoother low-speed motion
- improved trajectory tracking
- improved motion stability

The encoder system is expected to significantly improve:
- motion quality
- repeatability
- control precision

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
- quieter operation
- easier maintenance

Disadvantages:
- lower torque multiplication
- greater sensitivity to structural flex
- increased importance of lightweight design

Because there is no major reduction system currently planned, structural optimization becomes extremely important.

---

# Current Expected Limitations

Likely future limitations include:
- structural flex
- vibration
- resonance
- limited payload capability
- dynamic instability at higher acceleration

The current design is primarily optimized for:
- lightweight manipulation
- educational robotics
- research experimentation
- smooth low-load motion

rather than:
- heavy industrial payloads

---

# Structural Considerations

The current likely structural challenges include:
- shoulder flex
- elbow torsion
- bearing alignment
- motor mount rigidity

Even small amounts of structural flex can significantly reduce:
- repeatability
- motion smoothness
- end-effector precision

Improving stiffness while maintaining low mass will likely become one of the most important engineering challenges for OpenArm.

---

# Current Material Strategy

The current design uses:
- aluminum reinforcement
- PETG / PETG-CF structures
- bearing-supported joints

The current design philosophy attempts to balance:
- stiffness
- manufacturability
- affordability
- accessibility
- ease of assembly

---

# Future Improvements Being Considered

Potential future improvements:
- carbon fiber reinforcement
- Nylon-CF structural components
- dual-bearing support systems
- improved calibration systems
- gravity compensation
- advanced trajectory smoothing
- improved motion planning
- dynamic compensation systems

---

# Current Development Philosophy

The current development strategy prioritizes:
- learning through iteration
- engineering experimentation
- modularity
- manufacturability
- affordability
- open-source accessibility

The project intentionally focuses on:
- practical engineering
- experimentation
- iterative development
- continuous refinement

rather than immediately attempting industrial-grade performance.

---

# Future Work

Planned future work includes:
- payload analysis
- acceleration analysis
- inertia estimation
- resonance analysis
- repeatability testing
- thermal testing
- motion smoothing evaluation
- structural stiffness testing
- power consumption analysis

---

# Current Conclusion

The current lightweight direct-drive architecture appears mechanically feasible using standard NEMA17 motors for early OpenArm prototypes.

Current estimates suggest:
- standard NEMA17 motors should theoretically be capable of supporting the current lightweight structure
- the current design direction appears realistic for educational and research-focused robotics
- maintaining low distal mass remains extremely important

The current likely limiting factors are expected to become:
- structural stiffness
- vibration
- resonance
- motion tuning

rather than raw static holding torque alone.

Further prototyping and testing will ultimately determine:
- motion quality
- repeatability
- stiffness
- reliability
- practical payload capability

This document will continue evolving as OpenArm development progresses.
