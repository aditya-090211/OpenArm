# Executive Summary

This document analyzes key engineering aspects of the OpenArm 4-DOF CAN-bus robotic arm. We estimate **joint torques** using link lengths and masses (using Torque = *m·g·d*【24†L128-L136】) and apply a safety factor (~2×)【24†L192-L199】. Results show base/shoulder torques <1 Nm even without gearing. By using belt reductions (e.g. 5–7:1), inexpensive NEMA-17 steppers easily meet the load. In **Actuator & Encoder Selection**, we choose stepper motors for shoulder/elbow (axes 1–3) as they excel at low-speed holding torque【27†L109-L117】, with compact “pancake” NEMA-17s distally for low profile. We also review magnetic absolute encoders (AMS AS5047, 14-bit【34†L1137-L1140】; AS5600, 12-bit【51†L23-L30】) vs. cheaper quadrature encoders. 

The **Power & Wiring Architecture** uses a 24 V, 10 A power supply (e.g. MeanWell LRS-350-24) with a step-down regulator (buck) to 5 V for the Raspberry Pi. CAN bus wiring follows a **daisy-chain** topology【9†L503-L511】 with twisted pair (CAN_H/CAN_L) and 120 Ω termination resistors at each end【9†L525-L533】. We include protection (fuses/breakers) on the 24 V line. 

In **Joint Mechanical Design**, we detail bearing and belt choices: e.g. deep-groove ball bearings (625/606/608 sizes) and HTD-5M timing belts with pulley ratios to achieve the required gearing. We assume standard hardware (M3 screws, standoffs) per McMaster/Pololu catalogs and ensure cable routing within the arm profiles. 

**Control & Communication** covers the CAN message structure: unique node IDs for each joint, simple commands (e.g. `SET_POS`, `GET_STATUS`), and the plan to support closed-loop control using encoder feedback. Initially the arm will run open-loop to validate kinematics. 

Finally, the **Test Plan** outlines prototyping steps for single-joint assemblies. We will run tests for torque output (with known weights), thermal performance, current draw, and positional accuracy/backlash (comparing commanded vs. actual with an encoder or indicator). Metrics (e.g. step repeatability <0.1°, temperature <50 °C, no step loss) are defined and logged. A table of test cases and pass/fail criteria and a rough schedule (e.g. 2–3 weeks of incremental tests) is provided. Throughout, we note assumptions (e.g. link weights, target payload) and reference vendor datasheets or standard sources (Pololu, McMaster, AMS) where possible. 


# Torque & Transmission

**Intro:** Calculate worst-case joint torques by summing the moment of all masses *beyond* each joint. We assume each link is ~0.075 m long, with ~0.065 kg link mass (3 mm Al + 3D-printed parts) plus the distal motor mass (≈0.20 kg pancake, 0.30 kg standard). For vertical links, torque = *m·g·d*【24†L128-L136】. We add a safety factor of ~2.0 to account for dynamics【24†L192-L199】.

**Assumptions:**  
- Link lengths L1=L2≈0.075 m, L3 (wrist) ≈0.05 m.  
- Link mass ~0.065 kg, motor masses ~0.20 kg (pancake) or ~0.30 kg (standard).  
- End-effector (gripper) negligible or included in distal weight.  
- Gravity g=9.81 m/s², static worst-case.

**Calculations:** Below, "Mass at end" includes everything beyond that joint:

| Joint    | Link Length (m) | Mass at End (kg) | Torque = *m·g·L* (Nm) | With SF=2 (Nm) |
|----------|-----------------|------------------|----------------------|---------------|
| **Base (1)**     | 0.075           | 0.865 (all arm) | 0.64                | 1.28          |
| **Shoulder (2)** | 0.075           | 0.50            | 0.37                | 0.74          |
| **Elbow (3)**    | 0.075           | 0.23            | 0.17                | 0.34          |
| **Wrist (4)**    | 0.050           | 0.03            | 0.015               | 0.03          |

From these, even the largest static torque (~0.74 Nm at shoulder after SF) is modest. Applying a pulley reduction (for example, 5:1 or 7:1 via 70T:10T pulleys) reduces motor torque requirement by that ratio. E.g. shoulder motor sees ~0.74/5 ≈0.15 Nm. Typical NEMA-17 steppers have ~0.4 Nm holding torque【46†L199-L203】, so there is ample headroom.

**Sample Calculations:** Torque = *0.50 kg·9.81·0.075 = 0.37 Nm*. With SF=2 → 0.74 Nm at joint. With 5:1 gearing, motor torque ≈0.15 Nm, well below a 0.4 Nm motor rating【46†L199-L203】. The wrist torque is negligible (~0.03 Nm with SF), so even a low-power stepper suffices. 

**Summary:** Calculated torques assume static gravity load; dynamic effects (acceleration) are covered by SF≃2【24†L192-L199】. Results indicate low required motor torque (<0.2 Nm after gearing) for all joints except base, so the chosen stepper+pulley ratios are appropriate. 


# Actuator & Encoder Selection

**Intro:** OpenArm uses stepper motors on all joints (CAN-bus stepper modules) for simplicity and cost-effectiveness. Steppers provide high holding torque at low speed and do not require complex feedback for basic operation【27†L99-L105】. We select standard NEMA-17 steppers for base/shoulder and compact pancake NEMA-17 for elbow/wrist (to reduce weight/inertia). Magnetic absolute encoders are added on later revisions for closed-loop control.

**Stepper vs. BLDC/Servo:** Consumer robot arms (axes 1–3) often use steppers or high-torque servos【27†L109-L117】; wrists (axes 4–6) typically use lighter high-speed servos. Stepper pros: strong static torque (below ~300 RPM steppers outperform same-size BLDC torque by ~2–5×【27†L147-L148】), simple open-loop control. Cons: they can lose steps if overloaded【27†L99-L105】 and need current limiting drivers. We judged steppers suitable given our torque needs (~<1 Nm at joint) and educational focus.

**Pancake vs. Standard NEMA-17:** Pancake (short body) NEMA-17 motors reduce stack height at the cost of torque. For example, a 1.5 A pancake NEMA-17 (23 oz·in, 0.16 N·m)【43†L211-L219】 is used on distal joints, whereas a longer 1.2–1.7 A NEMA-17 (≈40 oz·in, 0.4 N·m)【46†L199-L203】 is used proximally.

| **Motor Type**        | **Step Angle** | **Holding Torque** | **Current** | **Example Source**        |
|-----------------------|---------------|-------------------|-----------|--------------------------|
| NEMA-17 42×48 mm (std) | 1.8°         | ~0.4 N·m (56 oz·in)【46†L199-L203】 | 1.2–1.7 A | StepperOnline, Pololu   |
| NEMA-17 Pancake (23 mm) | 1.8°       | ~0.16 N·m (23 oz·in)【43†L211-L219】| 1.5 A    | ZYLtech (e.g. 17HS15-PNCK) |

**Encoders:** We plan magnetic absolute encoders on each joint for feedback. Examples: AMS *AS5047D* (14-bit SPI/ABI output, 16384 CPR)【34†L1137-L1140】, AMS *AS5600* (12-bit PWM/I²C)【51†L23-L30】, or incremental rotary encoders (e.g. 500 CPR quadrature) if cost is critical. These sensors attach via the CANBUS-Stepper board connector. 

| **Encoder** | **Type**   | **Resolution** | **Output/Interface**        | **Notes/Source**            |
|-------------|------------|---------------|-----------------------------|-----------------------------|
| AMS AS5047D | Magnetic absolute | 14-bit (16384) | SPI or ABI (quadrature)      | DigiKey【34†L1137-L1140】   |
| AMS AS5600  | Magnetic absolute | 12-bit       | PWM or I²C (configurable)    | AMS Datasheet【51†L23-L30】 |
| Optical (e.g. CUI AMT10) | Incremental | 200–1000 PPR | Quadrature ABI             | low cost, requires MCU      |

**Summary:** We recommend low-cost NEMA-17 steppers as specified above. Tables list typical parameters; actual parts (e.g. StepperOnline 42×48 mm models) should meet or exceed these specs. For closed-loop, high-resolution magnetic encoders (14-bit AS5047 or similar) are available from AMS【34†L1137-L1140】.


# Power & Wiring Architecture

**Intro:** The arm uses a single 24 V DC power supply (rated ~10 A to allow for all steppers at peak current). The Raspberry Pi (5 V) is fed by a DC-DC buck converter from the 24 V bus. All 24 V wiring is fused/ protected. CAN bus wiring is **daisy-chained** between nodes, per recommended best practice【9†L503-L511】.

**24 V Distribution:** From the PSU (+24 V, GND), we route through a fuse/breaker (e.g. 10 A slow-blow) to protect the system. The +24 V and ground are distributed to each stepper driver. The buck converter taps +24 V and outputs regulated 5 V to the Pi (e.g. a 4–35 V to 5 V, 3 A module【40†L81-L90】). 

**5 V (Pi) Power:** Use a switching regulator (buck) sized for ~10 W, e.g. MeanWell DC-DC or similar (input 4–35 V, output 5 V【40†L81-L90】). Provide proper decoupling and set precisely to 5.0 V.

**CAN Bus Wiring:** Use a twisted shielded pair for CAN_H (usually yellow) and CAN_L (green). All nodes (stepper drivers) are on a single line (daisy-chain) as recommended【9†L503-L511】. Avoid star topology. Connect CAN_H/CAN_L sequentially: RPi (master) → Joint1 → Joint2 → … → Joint4 (end). Place 120 Ω termination resistors at both ends of the bus【9†L525-L533】 (e.g. one inside the Pi’s transceiver, one on the last node). Leave Pi end active and last node terminated. 

**Grounding/Shield:** Tie chassis ground at PSU and Pi ground. If cable shield is present, connect at one end. Ensure all grounds share a common reference.

| **Point**         | **Wires**                 | **Notes**                     |
|-------------------|---------------------------|-------------------------------|
| PSU outputs       | +24 V, GND (2 wires)      | Fused @ 10 A                  |
| To Pi (from buck) | +5 V, GND (2 wires)       | 5 A-rated wires               |
| Each Motor Node   | +24 V, GND (2 wires)      | Daisy from PSU, branch to buck |
| CAN Bus           | CAN_H, CAN_L (twisted pair) | Daisy-chain through all nodes |

```mermaid
flowchart LR
    PSU["24V Power Supply"] -- "+24V" --> FUSE["Fuse/Breaker"]
    FUSE -- "+24V" --> DIST["Power Distribution Node"]
    DIST -- "+24V" --> Act1["Actuator 1 (Base)"]
    DIST -- "+24V" --> Act2["Actuator 2 (Shoulder)"]
    DIST -- "+24V" --> Act3["Actuator 3 (Elbow)"]
    DIST -- "+24V" --> Act4["Actuator 4 (Wrist)"]
    PSU -- "+24V" --> BUCK["5V DC/DC Converter"]
    BUCK -- "+5V" --> RPi["Raspberry Pi (5V)"]
    BUCK -- "GND" --> RPi
    PSU -- "GND" --> DIST
    DIST -- "GND" --> Act1
    DIST -- "GND" --> Act2
    DIST -- "GND" --> Act3
    DIST -- "GND" --> Act4
