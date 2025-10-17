
---

# Single-Cycle & Pipelined RISC-V RV32I Processor Cores

This repository contains fully synthesizable **single-cycle** and **five-stage pipelined** RISC-V RV32I processor cores, implemented from scratch in **Verilog HDL**. Both designs adhere to the base 32-bit integer instruction set (RV32I) defined by the RISC-V specification and are deployable on the **Basys 3 FPGA** development board.

---

## 🔧 Features

✅ Implements the complete **RV32I** instruction set

✅ Developed in **Verilog HDL** using a modular architecture

✅ Supports both **single-cycle** and **pipelined** microarchitectures

✅ Fully synthesizable and tested on **Basys 3 (Artix-7)**

✅ Built-in **hardware debug interface** with 7-segment display and buttons

✅ Vivado simulation/testbench-ready

---

## 🧠 Architectures Implemented

### 🟢 Single-Cycle Processor

* **One instruction per clock cycle**
* Simple control and datapath logic
* Ideal for learning and debugging

### 🔵 Pipelined Processor (5-Stage)

* Implements the standard **IF–ID–EX–MEM–WB** pipeline stages
* Includes **hazard detection** and **data forwarding** units
* Improves performance with an observed **speedup of 1.4×**
* Maximum frequency: **\~60.2 MHz** (vs. 31.25 MHz in single-cycle design)

### CPI Measurement

The **CPI (Cycles Per Instruction)** of the pipelined processor was determined by running a mixed set of 14 RISC-V instructions containing arithmetic, memory, and control operations. The average CPI was measured to be **\~1.36**, confirming efficient pipelining behavior.

---

## ⬛ Basys 3 FPGA Implementation

Both processor versions are integrated with a **real-time debug interface** that operates via onboard components:

| Component             | Function                                   |
| --------------------- | ------------------------------------------ |
| **W16**               | Reset (one-pulse)                          |
| **V15**               | Clock Enable / Execution Toggle            |
| **BTNU/BTND**         | Scroll through register or memory indices  |
| **BTNL/BTNR**         | Switch between memory/register views       |
| **BTNC**              | Toggle between address and value display   |
| **7-Segment Display** | Shows PC, register/memory values or EBREAK |
| **LED P3**            | Indicates program termination (via EBREAK) |
| **LED U19**           | Blinks with active clock                   |

📘 See [`RISCV_Scroll_Menu_Manual.txt`](./RISCV_operation_mannual_BASYS3.txt) for full operation guide.

---

## 📊 Resource Utilization Comparison

| Metric              | Single-Cycle | Pipelined    |
| ------------------- | ------------ | ------------ |
| **Slice LUTs**      | 1543 (7.42%) | 1802 (8.66%) |
| **Slice Registers** | 1123 (2.70%) | 1628 (3.91%) |
| **F7 Muxes**        | 449          | 448          |
| **F8 Muxes**        | 108          | 137          |

📌 *The pipelined design shows moderate resource increase due to stage registers and hazard handling units, while offering significantly improved throughput.*

---

## 🧩 Modular Design

Both designs are built using modular Verilog components:

* **Program Counter (PC)**
* **Instruction Memory (.coe ROM)**
* **Control Unit**
* **ALU**
* **Immediate Generator**
* **Register File**
* **Data Memory**
* **Writeback Logic**
* **Hazard Detection Unit** *(pipelined only)*
* **Forwarding Unit** *(pipelined only)*

---

## 🛠️ Requirements

* **Vivado** (Design, Synthesis, Simulation, Bitstream Generation)
* (Optional) **RISC-V Toolchain** for generating binary/test programs
* **.coe file generator** or precompiled assembly instructions

---

## 📷 Demo Videos

<p align="center">
  <a href="https://youtu.be/ICoTxWUAC34">
    <img src="https://img.youtube.com/vi/ICoTxWUAC34/maxresdefault.jpg" alt="Single-Cycle Demo" width="600"/>
  </a>
</p>

<p align="center">
  <a href="https://youtu.be/16mvLp_AaZ0">
    <img src="https://img.youtube.com/vi/16mvLp_AaZ0/maxresdefault.jpg" alt="Pipelined Demo" width="600"/>
  </a>
</p>

---

## 📚 Documentation

* [`RISC-V.pdf`](./RISC-V.pdf) — Full architecture explanation, datapaths, and control logic
* [`RISCV_Scroll_Menu_Manual.txt`](./RISCV_operation_mannual_BASYS3.txt) — Operation guide for FPGA debug interface

---

## 💡 Future Improvements

* Add support for **RISC-V M extension** (multiply/divide)
* Implement **compressed (C) instruction set**
* Introduce **basic branch prediction**
* Add **instruction/data cache units**
* Develop a **UART-based serial monitor interface**

---
