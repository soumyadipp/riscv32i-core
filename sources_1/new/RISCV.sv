`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Soumyadip Manna
// Design Name: RISC-V Processor
// Module Name: RISCV
// Description: Top-level RISC-V processor with debug memory/register access
//////////////////////////////////////////////////////////////////////////////////

module RISCV(
    input  logic clk,
    input  logic reset,

    input logic[31:0] debug_addr, 
    // Outputs for observation (optional)
    output logic [31:0] pc, instr,
                        memWdata, addr, aluin1, aluin2,
                        Simm, Jimm, Bimm, Iimm, memRdata,
        
    output logic [4:0]  rs1Id, rs2Id, rdId,
    output logic [3:0]  memWmask, aluCtrl,
    output logic        isAlureg, regWrite, isJAL, isJALR,
                        isBranch, isLUI, isAUIPC, isAluimm, isLoad, isStore, isShamt,
   output logic [31:0] debugdata_Dmem,debugdata_Reg
);

    // Internal control signals
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic       isZero;



    // === Instruction Decode ===
    Decoder decode1 (
        .instr(instr),
        .isAlureg(isAlureg),
        .isAluimm(isAluimm),
        .regWrite(regWrite),
        .isJAL(isJAL),
        .isJALR(isJALR),
        .isBranch(isBranch),
        .isLUI(isLUI),
        .isAUIPC(isAUIPC),
        .isLoad(isLoad),
        .isStore(isStore)
    );

    aluDecode aludecode1 (
        .funct3(funct3),
        .funct7(funct7),
        .instr_5(instr[5]),
        .isBranch(isBranch),
        .isAlureg(isAlureg),
        .isAluimm(isAluimm),
        .aluCtrl(aluCtrl),
        .isShamt(isShamt)
    );

    // === Datapath ===
    dataPath path1 (
        .clk(clk),
        .reset(reset),
        .isAlureg(isAlureg),
        .regWrite(regWrite),
        .isJAL(isJAL),
        .isJALR(isJALR),
        .isBranch(isBranch),
        .isLUI(isLUI),
        .isAUIPC(isAUIPC),
        .isLoad(isLoad),
        .isStore(isStore),
        .isShamt(isShamt),
        .funct3(funct3),
        .aluCtrl(aluCtrl),
        .instr(instr),
        .memRdata(memRdata),
        .debug_addr(debug_addr),
        .debugdata_Reg(debugdata_Reg),
        .pc(pc),
        .aluOut(addr),
        .memWdata(memWdata),
        .aluin1(aluin1),
        .aluin2(aluin2),
        .Simm(Simm),
        .Bimm(Bimm),
        .Jimm(Jimm),
        .Iimm(Iimm),
        .rs1Id(rs1Id),
        .rs2Id(rs2Id),
        .rdId(rdId),
        .memWmask(memWmask),
        .isZero(isZero)

       
    );

    // === Instruction Memory ===
    dist_mem_gen_0 imem_1 (
        .a(pc[9:2]),
        .spo(instr)
    );

    // === Data Memory (supports debug read) ===
    DMem dmem1 (
        .clk(clk),
        .memWmask({4{isStore}} & memWmask),
        .a(addr),
        .wd(memWdata),
        .rd(memRdata),
        .debug_addr(debug_addr),
        .debugdata_Dmem(debugdata_Dmem)

       
    );

 
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

   


endmodule
