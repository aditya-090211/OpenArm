# Test Plan & Metrics

**Intro:** We will build and test a single-joint prototype first, then scale to the full arm. Tests include measuring torque capacity, thermal performance, current draw, and position accuracy/repeatability. Data are logged for analysis.

**Test Steps:**  
1. **Bench Assembly:** Mount one joint (motor, belt, pulley, bearing) on test frame. Use a known weight on the output to simulate load.  
2. **Torque Test:** Attach weights to the arm; command motor to hold horizontal. Increase weight until motor stalls. Measure stall torque vs. predicted.  
3. **Current & Thermal:** Run continuous movements (e.g. back-and-forth) for 10 min. Measure motor driver current (via shunt) and surface temperature. Verify within limits.  
4. **Backlash/Accuracy:** Attach a dial indicator or use the encoder. Command +Δ and -Δ steps from a known position. Measure position error and hysteresis. Ensure backlash <0.1° if possible.  
5. **Repeatability:** Run a small movement (e.g. 100 steps) 10×, record end position from encoder. Compute standard deviation.  

**Metrics & Criteria:**  

| Test            | Metric                 | Method                                 | Pass/Fail Criterion            |
|-----------------|------------------------|----------------------------------------|-------------------------------|
| **Holding Torque** | Nm at motor for given weight | Gradually increase load until skip | ≥ computed need (with SF)    |
| **Current**     | Amps (peak & RMS)      | Multimeter on driver shunt during motion | Below driver rating (e.g. <2A) |
| **Temperature** | °C rise after 10 min   | Thermal probe on motor/driver          | <50 °C (for 24 V, 5 A wires)  |
| **Backlash**    | Degrees                | Angle difference +/- small moves       | <0.1° (at low speed)         |
| **Repeatability** | Std. dev. of angle   | Repeated move/error                    | ≤0.2° (for 1σ)               |

**Data Logging:** During tests, log timestamped CAN/serial output: commanded steps, encoder position, current, temp. Use CSV format with columns (time, pos, curr, temp, [error flags]). This ensures later analysis. 

**Timeline:** Build prototype hardware (1 week), perform basic motion and torque tests (1 week), implement CAN firmware and encoder reading (1 week), perform accuracy/repeatability tests (1 week). Iterate designs if any test fails (e.g. insufficient torque or excessive heat). 

**Summary:** The test plan emphasizes verifying our torque estimates and ensuring the arm’s performance meets design assumptions. All assumptions (masses, gear ratios, etc.) should be documented. If tests deviate, revisit design parameters and update calculations. 
