# Test Plan — First Hardware Prototype

Testing protocol for the first physical OpenArm prototype. The plan is to build and test a single joint assembly before scaling to the full arm.

---

## Approach

Test one joint end-to-end before committing to multi-joint hardware. A single-joint testbed validates:
- Motor sizing and belt reduction selection
- CAN communication and firmware
- Encoder feedback accuracy
- Thermal performance under load
- Positional accuracy and backlash

Fixing problems at the single-joint level is much cheaper than fixing them on a fully assembled arm.

---

## Test Setup

1. Mount a single joint (motor, belt, pulley, bearing, shaft) on a rigid test frame
2. Attach a known weight to the output shaft to simulate arm load
3. Connect CANBUS-Stepper node to Raspberry Pi
4. Log all CAN telemetry to CSV during tests

---

## Test Sequence

### 1. Basic Motion Validation

Before loading anything, verify the joint moves correctly:
- Send position commands, verify motion direction and magnitude
- Check for step loss at low speeds
- Verify CAN communication: ping nodes, confirm IDs, check error flags

Pass criterion: Joint moves to commanded position consistently with no CAN errors.

### 2. Torque / Load Test

- Attach increasing weights to the output lever
- Command motor to hold horizontal (worst-case gravity load)
- Increase weight until step loss occurs
- Record stall torque vs. driver current setting

Pass criterion: Holds computed load with 2× safety factor (see `Research/torque_analysis.md`).

### 3. Current and Thermal Test

- Run continuous back-and-forth motion for 10 minutes
- Measure peak and RMS motor driver current via shunt resistor
- Monitor motor and driver surface temperature with thermal probe

Pass criteria:
- Current stays below driver rating
- Motor surface temperature below 50°C after 10 minutes

### 4. Backlash and Accuracy Test

- Command +10° and -10° steps from a known reference position
- Measure actual position via encoder (or dial indicator if encoder not yet integrated)
- Compute hysteresis: difference in position when approaching from opposite directions

Pass criterion: Backlash below 0.5° at joint output. Initial target — will be revised based on actual results.

### 5. Repeatability Test

- Command the same 100-step move 20 times
- Record final position from encoder after each move
- Compute standard deviation

Pass criterion: Standard deviation ≤ 0.2° (1σ). This corresponds to roughly 0.5mm end effector uncertainty at 150mm reach.

---

## Metrics

| Test | Method | Pass Criterion |
|---|---|---|
| Basic motion | CAN position commands | Consistent, no errors |
| Holding torque | Weight on output lever, increase until stall | Holds computed load × 2 |
| Current draw | Shunt measurement during motion | Below driver rating |
| Temperature | Thermal probe after 10 min continuous | < 50°C |
| Backlash | Encoder, approach from both directions | < 0.5° |
| Repeatability | 20 repeated moves, encoder | Std dev ≤ 0.2° |

---

## Data Logging

Log all tests to CSV:

```
timestamp_ms, commanded_pos_deg, encoder_pos_deg, current_A, temp_C, error_flags
```

---

## Estimated Timeline

| Phase | Duration |
|---|---|
| Single-joint hardware assembly | ~1 week |
| Basic motion and torque tests | ~1 week |
| CAN firmware and encoder integration | ~1 week |
| Accuracy and repeatability tests | ~1 week |
| Iterate on failures | 1–2 weeks additional |

Hardware always takes longer than expected.

---

## Known Risks

**Belt tension:** Too loose causes backlash and tooth skipping; too tight causes high bearing load and belt wear. Will need to iterate on this.

**Encoder mounting tolerance:** Magnetic encoders are sensitive to magnet-to-sensor gap (typically 0.5–3mm). If the gap is outside spec, readings are unreliable. The CAD needs to enforce this constraint explicitly.

**Step loss at speed:** Steppers lose steps if driven too fast or if load inertia is too high. Fix is reducing speed, increasing driver current, or adjusting the belt reduction ratio.

**Thermal limits on CANBUS-Stepper boards:** These boards have their own thermal constraints. Needs to be verified under sustained load before committing to a motor current setting.
