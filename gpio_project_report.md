# General Purpose Input/Output (GPIO) IP Core
**Author:** Thammineni Naren Chowdary   
**Branch:** Electronics and Communication Engineering  

---

## 📘 Project Overview

This project presents a 32-bit **GPIO IP Core** designed for integration in SoC environments. It conforms to the **OpenCores GPIO v1.2** specification and supports the **AMBA APB (Advanced Peripheral Bus)** interface.

![image](https://github.com/user-attachments/assets/8922776f-faef-45ec-ad75-4ca7b1f56cb1)

The core includes:
- Configurable direction control
- Data registers
- Interrupt support
- Auxiliary input synchronization
- Synthesizable for FPGAs

---

## 💠 Design Features

### 🔌 Protocols
- **Bus Interface:** AMBA APB
- **Interrupts:** Edge-triggered, per-pin configurable
- **Aux Input:** 32-bit synchronized override input

### 🧹 Submodules

#### 1. APB Slave Interface
![image](https://github.com/user-attachments/assets/5995e74f-81d9-4921-87c3-618477ed3fcd)

- Implements a 3-state FSM: IDLE, SETUP, ENABLE
- Handles APB signals: `psel`, `penable`, `pwrite`, `paddr`, `pwdata`
- Generates `gpio_we`, `gpio_dat_i`, and `gpio_addr`
- Outputs `irq`, `sysclk`, and `sysrst`

**Simulation using ModelSim:** 
![image](https://github.com/user-attachments/assets/15fee3c6-76ea-4586-87ef-fe2f7cad9e45)

Waveform shows the transaction sequence:
- Write access to register at 0x04 with data 0x12345678
- Read access from register at 0x04 after driving it

**Synthesis using Quartus Prime:** Successfully synthesized for Cyclone V
![image](https://github.com/user-attachments/assets/2cc8dede-e944-4abe-bb72-8794f462a657)

#### 2. GPIO Register Block
![image](https://github.com/user-attachments/assets/ab02705e-803e-478d-bb2b-601926b9db48)

- Implements all registers as per OpenCores GPIO spec
- Registers include: `RGPIO_OUT`, `RGPIO_IN`, `RGPIO_OE`, `RGPIO_INTE`, `RGPIO_PTRIG`, `RGPIO_AUX`, `RGPIO_CTRL`, `RGPIO_INTS`, `RGPIO_ECLK`, `RGPIO_NEC`
- Responsible for generating `gpio_inta_o` interrupt signal

**Simulation using ModelSim:**  
![image](https://github.com/user-attachments/assets/71f7b0db-ff15-4cb1-acfd-4ecae480a49b)

Waveform includes:
- Writing to output register `RGPIO_OUT`
- Enabling output using `RGPIO_OE`
- Changing input value and observing interrupt flag
- Reading interrupt status from `RGPIO_INTS`

**Synthesis using Quartus Prime:** Synthesized successfully with all logic mapped
![image](https://github.com/user-attachments/assets/d938b913-8c83-41de-8e1e-c12195ba10e3)

#### 3. AUX Input Interface
![image](https://github.com/user-attachments/assets/4d99a32b-92cb-4a8e-bc18-36c0115d4f53)

- Synchronizes 32-bit asynchronous input to `sys_clk`
- Eliminates metastability using internal register
- Used for external override of output

**Simulation using ModelSim:**
![image](https://github.com/user-attachments/assets/d32a60a2-965e-4c83-97f9-41a36925f680)

Waveform demonstrates:
- Glitch-free synchronization of `aux_in` to `aux_i`
- Changes in input appear on output only after a clock edge

**Synthesis using Quartus Prime:** Clean synthesis and minimal resource usage
![image](https://github.com/user-attachments/assets/60bfe9b4-10d6-4be4-880e-641af716aa48)

#### 4. I/O Interface
![image](https://github.com/user-attachments/assets/24eb9f8b-5478-4eeb-85ee-9c09e719377f)

- Manages 32-bit bidirectional `pad_io` lines
- Tristate control using `gpio_oe`
- Drives `gpio_data_out` or reads to `gpio_data_in`

**Simulation using ModelSim:**  
![image](https://github.com/user-attachments/assets/f8480dc7-b13c-4866-8037-394789f3d5bd)

Waveform shows:
- Output drive when `gpio_oe` = 1
- High-Z state and external pad value sampling when `gpio_oe` = 0
- Bidirectional pad interaction is confirmed

**Synthesis using Quartus Prime:** All buffers and assignments mapped successfully
![image](https://github.com/user-attachments/assets/b778845f-076e-4071-95af-d5fcd78814a1)

---

### 📊 Top-Level Module
![image](https://github.com/user-attachments/assets/67a1b00a-abea-4469-aad3-06c5641b5a23)

The `gpio_top` integrates all submodules:
- Connects APB, AUX, Register, and I/O Interface
- Wires data/ctrl signals across modules
- Drives external pads and receives interrupts

**Simulation using ModelSim:**  
![image](https://github.com/user-attachments/assets/60e67cb1-b2da-470a-824a-2e71417e22a3)

Waveform includes:
- Writing values to registers via APB
- External pad driving `pad_driver` and `pad_drive_en`
- Interrupts triggered based on `RGPIO_INTE` and `RGPIO_PTRIG`
- Readback of `RGPIO_INTS` confirms interrupt occurrence

**Synthesis using Quartus Prime:** Integrated system successfully synthesized for Cyclone V
![image](https://github.com/user-attachments/assets/bfd05d82-e5be-4c0e-910d-6b7db9ed9a66)

---

## 📀 Register Map

| Address | Name         | Width  | Access       | Description                          |
|---------|--------------|--------|--------------|--------------------------------------|
| 0x00    | RGPIO_IN     | 32-bit | Read-only    | Current logic level on input pins    |
| 0x04    | RGPIO_OUT    | 32-bit | Read/Write   | Output data to GPIO pins             |
| 0x08    | RGPIO_OE     | 32-bit | Read/Write   | Output enable (1 = output)           |
| 0x0C    | RGPIO_INTE   | 32-bit | Read/Write   | Interrupt enable per pin             |
| 0x10    | RGPIO_PTRIG  | 32-bit | Read/Write   | Edge polarity trigger                |
| 0x14    | RGPIO_AUX    | 32-bit | Read/Write   | Auxiliary data input                 |
| 0x18    | RGPIO_CTRL   | 2-bit  | Read/Write   | INT enable + latch                   |
| 0x1C    | RGPIO_INTS   | 32-bit | Read/Write   | Interrupt status (write-1 to clear)  |
| 0x20    | RGPIO_ECLK   | 32-bit | Read/Write   | External clock control               |
| 0x24    | RGPIO_NEC    | 32-bit | Read/Write   | Negative edge config (optional)      |

---

## 🔊 Interrupt Handling

- **RGPIO_INTE:** Enables interrupt per pin
- **RGPIO_PTRIG:** Selects rising/falling edge
- **RGPIO_INTS:** Captures pending interrupts
- **RGPIO_CTRL:** Bit 0 = Global INT enable, Bit 1 = Latch enable
- **irq output** is asserted when any configured condition matches

---

## 💡 Synthesis Summary (Quartus Prime)

| Metric               | Value              |
|----------------------|--------------------|
| Total Logic Elements | ~280–350          |
| Combinational ALUTs  | ~150–200          |
| Registers Used       | ~130–160          |
| I/O Pins             | 69 (32 GPIO + misc) |
| Maximum Fmax         | ~80–100 MHz        |
| Compilation Time     | ~25–30 sec         |

---

## 📅 Conclusion

- Designed a 32-bit GPIO IP Core conforming to OpenCores spec
- Verified using ModelSim with detailed waveforms
- Synthesized using Quartus Prime targeting FPGA
- Modular structure aids clarity and reuse
- Future scope: debounce logic, AXI-lite interface, dynamic INT mapping

