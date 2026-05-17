# Cost Reduction Notes

## Current Situation

One of the largest challenges with OpenArm right now is:
# cost

The current estimated BOM (Bill of Materials) is approximately:

$$ ₹49,802 $$

which is significantly more expensive than originally intended.

For a project focused on:
- accessibility
- education
- open-source robotics
- affordability

this cost is currently too high.

Reducing the overall system cost is now one of the highest priorities of the project.

---

# Current Estimated BOM

| Part | Quantity | Approx Cost |
|---|---|---|
| Nema 17 | 2 | ₹2 |
| Nema 17 Pancake | 2 | ₹2000 |
| CAN Bus Steppers | 4 | ₹31,200 |
| 3D Prints | 1 | ₹2000 |
| Aluminium Sheets | 1 | ₹5000 |
| Misc Wiring | 1 | ₹2000 |
| Power Supply | 1 | ₹1000 |
| Belts | 2 | ₹1000 |
| Bolts / Hardware | 1 | ₹2000 |
| Bearings | 6 | ₹3600 |

---

# Major Cost Contributors

The largest cost contributor by far is currently:

## CAN Bus Stepper Motors

Current estimate:

$$ ₹31,200 $$

This alone makes up the majority of the total system cost.

While CAN-based integrated steppers provide:
- cleaner wiring
- better scalability
- easier networking
- closed-loop capability
- advanced control features

they are currently too expensive for the long-term goals of OpenArm.

---

# Why Cost Reduction Matters

The original purpose of OpenArm was to create:
- an affordable robotics platform
- a learning platform for students
- a low-cost research arm
- an accessible open-source system

At the current price point:
- the arm becomes difficult for students to build
- replication becomes expensive
- educational accessibility decreases
- experimentation becomes harder

A major long-term goal is reducing the cost enough that:
- schools can build it
- students can experiment with robotics
- developers can modify it freely
- researchers can prototype cheaply

---

# Current Cost Reduction Research Areas

The project is actively exploring multiple methods to reduce cost.

---

# 1. Alternative Motor Systems

The current CAN stepper setup is likely overkill for early development.

Possible alternatives being researched:
- standard stepper drivers
- external CAN controllers
- lower-cost closed-loop steppers
- hybrid servo systems
- belt reductions for torque multiplication

Potential benefit:
- very large cost reduction

Potential downside:
- more wiring
- more software complexity
- lower integration quality

---

# 2. Structural Optimization

Current structure uses:
- aluminum sheets
- large printed parts

Research is ongoing into:
- reducing material usage
- topology optimization
- lighter brackets
- smaller support structures
- modular printed reinforcements

Goals:
- reduce manufacturing cost
- reduce weight
- reduce assembly complexity

---

# 3. Reducing Part Count

Another major focus is:
# reducing total part count

Current areas being optimized:
- bearing count
- bolt count
- bracket count
- belt routing complexity
- mounting hardware

Reducing part count improves:
- reliability
- assembly speed
- maintenance
- cost

---

# 4. Manufacturing Simplification

The arm is also being redesigned around:
- easier fabrication
- fewer custom parts
- more printable geometry
- easier assembly

The goal is to reduce dependency on:
- expensive machining
- precision manufacturing
- difficult assembly steps

---

# 5. Electronics Simplification

Future revisions may reduce:
- wiring complexity
- connector count
- PCB complexity
- power distribution complexity

This could reduce both:
- manufacturing cost
- debugging difficulty

---

# Current Tradeoff Problem

A major challenge in robotics is balancing:

| Lower Cost | Higher Performance |
|---|---|
| cheaper motors | better precision |
| fewer parts | higher rigidity |
| lighter structures | stronger structures |
| simpler electronics | advanced features |

OpenArm is currently trying to find:
# the best balance between performance and affordability

rather than maximizing performance at all costs.

---

# Important Realization

One of the biggest lessons learned during development is:

# robotics becomes expensive extremely quickly

Even relatively small robotic arms can become costly because of:
- motors
- precision components
- bearings
- electronics
- structural hardware

The software side of robotics is often dramatically cheaper than the hardware side.

---

# Why the Current Prototype Still Matters

Even though the current BOM is expensive, this phase is still valuable because it allows:
- testing kinematics
- validating motion planning
- developing software
- experimenting with control systems
- understanding hardware requirements

before aggressively optimizing for cost.

The first version of a robotics platform is rarely the cheapest version.

---

# Long-Term Cost Goals

Future versions of OpenArm aim to:
- significantly reduce motor costs
- simplify electronics
- reduce structural complexity
- reduce manufacturing difficulty
- improve accessibility
- create educational-friendly versions

The long-term vision is a robotic arm platform that is:
- open-source
- affordable
- modular
- educational
- scalable

without sacrificing too much capability.

---

# Current Development Philosophy

The project is currently prioritizing:
1. functionality
2. mathematical correctness
3. motion planning
4. software architecture
5. reliability

before fully optimizing for:
- manufacturing cost
- assembly simplicity
- mass reproducibility

This allows the core robotics systems to mature first before aggressive cost optimization begins.

---

# Future Possibilities

Potential future directions include:
- educational kits
- lower-cost variants
- modular upgrade systems
- swappable motor systems
- simplified beginner versions
- lightweight research versions

The overall goal is to eventually make advanced robotics more accessible to:
- students
- schools
- hobbyists
- researchers
- independent developers
