# General Purpose Input/Output (GPIO) IP Core  
**Author:** Thammineni Naren Chowdary   
**Branch:** Electronics and Communication Engineering  

---

## 📘 Project Overview

This project presents a 32-bit **GPIO IP Core** designed for integration in SoC environments. It conforms to the **OpenCores GPIO v1.2** specification and supports the **AMBA APB (Advanced Peripheral Bus)** interface.

The core includes:
- Configurable direction control
- Data registers
- Interrupt support
- Auxiliary input synchronization
- Synthesizable for FPGAs

---

## 🛠️ Design Features

### 🔌 Protocols
- **Bus Interface:** AMBA APB
- **Interrupts:** Edge-triggered, per-pin configurable
- **Aux Input:** 32-bit synchronized override input

### 🧩 Submodules
- **APB Slave Interface** – FSM-controlled APB transaction handling
- **GPIO Register Bank** – Register map with direction, data, and interrupt logic
- **Auxiliary Input Block** – Synchronizes external async signals
- **I/O Pad Interface** – Manages tristate bidirectional I/O pads

### 💾 Registers
| Address | Name         | Width  | Description                         |
|---------|--------------|--------|-------------------------------------|
| 0x00    | RGPIO_IN     | 32-bit | Read-only input pin values          |
| 0x04    | RGPIO_OUT    | 32-bit | Output data                         |
| 0x08    | RGPIO_OE     | 32-bit | Output enable per pin               |
| 0x0C    | RGPIO_INTE   | 32-bit | Interrupt enable                    |
| 0x10    | RGPIO_PTRIG  | 32-bit | Edge polarity trigger               |
| 0x14    | RGPIO_AUX    | 32-bit | Auxiliary input override            |
| 0x18    | RGPIO_CTRL   | 2-bit  | Global INT enable, latch status     |
| 0x1C    | RGPIO_INTS   | 32-bit | Interrupt status                    |
| 0x20    | RGPIO_ECLK   | 32-bit | External clock input                |
| 0x24    | RGPIO_NEC    | 32-bit | Negative edge config (optional)     |

---

## 🖼️ Block Diagrams
- ✅ Top Module Diagram
- ✅ APB Slave Interface
- ✅ GPIO Register Bank
- ✅ AUX Input Block
- ✅ I/O Interface

_All diagrams are inserted in the report before their respective module summaries._

---

## 📈 ModelSim Simulation Outputs
Waveforms have been captured and added for:
- ✅ Top Module
- ✅ APB Interface
- ✅ Register Bank
- ✅ AUX Input
- ✅ I/O Interface

Each waveform illustrates proper signal propagation and expected functional behavior.

---

## 🔧 Synthesis Summary (Quartus Prime)
- Target: Intel Cyclone V FPGA
- Logic Elements: ~280–350
- Registers: ~130–160
- Max Frequency: ~80–100 MHz
- I/O Pins: 69 total (32 GPIO + AUX + APB)

---

## ✅ Conclusion

This project successfully implements a modular GPIO IP core that:
- Integrates smoothly via APB
- Supports software configuration
- Handles edge-triggered interrupts
- Can be extended to support additional features like debounce and AXI-lite

The design is fully functional and synthesizable for FPGA prototyping and SoC applications.

---

