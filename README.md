# Single-Cycle RISC-V RV32I Core

This repository contains a fully synthesizable **single-cycle RISC-V RV32I processor** core, implemented from scratch in Verilog. The design adheres to the base 32-bit integer instruction set (RV32I) defined by the RISC-V specification.

---

## Features

- Implements the full **RV32I** instruction set
- **Single-cycle execution** — each instruction completes in one clock cycle
- Written in **Verilog HDL**
- Modular design (datapath, control unit, ALU, register file, etc.)
- Compatible with **FPGA synthesis** (tested on Xilinx Basys 3)
- Sample instruction memory initialization file and programs included
- Simple **testbench setup** for simulation

---

## Architecture Overview

The single-cycle processor executes one instruction per clock cycle. It includes the following modules:

- **Instruction Memory**: ROM holding preloaded `.hex` instructions
- **Program Counter (PC)**: 32-bit counter pointing to current instruction
- **Control Unit**: Generates control signals based on the opcode
- **Immediate Generator**: Extracts and sign-extends immediates
- **Register File**: 31 general-purpose registers (`x1`–`x31`) and 2 Special registers(`x0`–`PC`)
- **ALU**: Performs arithmetic and logical operations
- **Data Memory**: For load and store operations
- **Write-back Logic**: Returns ALU or memory result to registers

---

## Prerequisites

- **Vivado** (for simulation, synthesis and FPGA deployment)
- **RISC-V toolchain** (optional, for compiling test programs)

---

📘 **For a detailed explanation of the architecture, dataflow, and control logic, refer to [`RISC-V.pdf`](./RISC-V.pdf)** provided in the root directory.
