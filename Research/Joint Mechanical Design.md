# Joint Mechanical Design

**Intro:** Each joint uses a shaft supported by deep-groove ball bearings and turned by a timing-belt/pulley reduction. We use common bearing sizes (625, 606, 608) and HTD-5M belts/pulleys. Spacer standoffs (e.g. M3×6 mm, hex) and screws (DIN7991 countersunk) are chosen to clear motor flanges and belt teeth per Pololu/McMaster standards.

**Bearings:**  
- **625ZZ**: 5 mm ID × 16 mm OD × 5 mm width【17†L76-L84】.  
- **606ZZ**: 6 mm ID × 17 mm OD × 6 mm width (for base rotation).  


Bearings are pressed into 3D-printed hubs with appropriate interference fit. 


**Standards:**  
- Fasteners: use metric M3 screws/standoffs (e.g. 6 mm length) as in Pololu hex standoff kits.  
- Belt tension: incorporate a small idler or sliding motor mount if needed.  
- Cable routing: plan harness through hollow joints or along link walls, with strain relief. Avoid sharp bends at joints.


# Control & Communication

**Intro:** The Raspberry Pi is the master, communicating with four CAN nodes (one per joint). Each CANBUS-Stepper node has a unique ID. We will define a simple message set: e.g. `0x100+ID` for commands to set position or move, `0x200+ID` for status replies. Initial control is open-loop (send step commands); later we may implement closed-loop PID using encoder feedback.

**CAN Message Architecture:**  
- **Node IDs:** Joint1=1 (base), Joint2=2 (shoulder), etc.  
- **CAN IDs:** For example, standard 11-bit IDs: 0x101 for Joint1 command, 0x201 for Joint1 status (arbitration scheme as needed).  
- **Commands:** `SET_TARGET_POS` (absolute angle), `SET_STEP_RATE`, `SET_CURRENT_LIMIT`, `STOP`, etc.  
- **Status:** Node returns its current position (raw step count or encoder count) and temperature or errors.

**Loop Control:** Initially, drive steppers in open-loop (no encoder feedback) for simplicity. Each stepper board could optionally use its encoder to verify position; we plan to add a closed-loop mode where the board adjusts stepping to match an encoder count. This requires more firmware development but greatly improves repeatability.

**Testing Procedure:** Validate CAN link by pinging each node and reading an ID. Test move commands with no load first. Use `GET_POS` to confirm steps. Ensure messages follow arbitration (lower ID higher priority) and that bus errors are trapped.

```mermaid
flowchart LR
    Pi["Raspberry Pi (CAN master)"] -->|CAN| Node1["Joint 1 Node (ID=1)"]
    Pi -->|CAN| Node2["Joint 2 Node (ID=2)"]
    Pi -->|CAN| Node3["Joint 3 Node (ID=3)"]
    Pi -->|CAN| Node4["Joint 4 Node (ID=4)"]
    subgraph CAN_Bus
        direction TB
        Node1 --> Node2
        Node2 --> Node3
        Node3 --> Node4
    end
