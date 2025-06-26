`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Soumyadip Manna
// 
// Design Name: RISC-V Processor - Datapath
// Module Name: dataPath
// Description: RISC-V datapath with debug register read support
//////////////////////////////////////////////////////////////////////////////////

module dataPath(
    input  logic        clk,
    input  logic        reset,
    input  logic        isAlureg, regWrite, isJAL, isJALR,
                        isBranch, isLUI, isAUIPC, isLoad, isStore, isShamt,
    input  logic [2:0]  funct3,
    input  logic [3:0]  aluCtrl,
    input  logic [31:0] instr,
    input  logic [31:0] memRdata,
    input  logic [31:0] debug_addr,
    // Debug register interface


    // Outputs to top
    output logic [31:0] debugdata_Reg,
    output logic [31:0] pc, aluOut, memWdata,
    output logic [31:0] aluin1, aluin2,
    output logic [31:0] Simm, Bimm, Jimm, Iimm,
    output logic [4:0]  rs1Id, rs2Id, rdId,
    output logic [3:0]  memWmask,
    output logic        isZero
);

    // === Internal Wires ===
    logic [31:0] pcNext, pcplus4, rd2, aluin2pre, pcplusImm, wd3, loadData;
    logic [1:0]  memByteAccess, memHalfwordAccess;
    logic [15:0] loadHalfWord;
    logic [7:0]  loadByte;
    logic        loadSign;
    logic [31:0] Uimm;
    logic [4:0]  shamt;

    // === Program Counter ===
    FF pc_reg (
        .clk(clk),
        .reset(reset),
        .d(pcNext),
        .q(pc)
    );

    // === PC + 4 ===
    adder pc_adder (
        .ip1(pc),
        .ip2(32'd4),
        .op(pcplus4)
    );

    // === Register File ===
    RegFile regfile (
        .clk(clk),
        .we3(regWrite),
        .a1(rs1Id),
        .a2(rs2Id),
        .a3(rdId),
        .wd3(wd3),
        .debug_addr(debug_addr),
        .rd1(aluin1),
        .rd2(rd2),
        .debugdata_Reg(debugdata_Reg)
    );

    // === ALU ===
    alu alu_unit (
        .aluCtrl(aluCtrl),
        .op1(aluin1),
        .op2(aluin2),
        .aluOut(aluOut),
        .isZero(isZero)
    );

    // === Immediate Extraction ===
    assign rs1Id = instr[19:15];
    assign rs2Id = instr[24:20];
    assign rdId  = instr[11:7];

    assign Uimm = {instr[31], instr[30:12], {12{1'b0}}};
    assign Iimm = {{21{instr[31]}}, instr[30:20]};
    assign Simm = {{21{instr[31]}}, instr[30:25], instr[11:7]};
    assign Bimm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
    assign Jimm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};

    assign shamt = isAlureg ? rd2[4:0] : instr[24:20];

    // === Load Data Formatting ===
    assign memByteAccess     = funct3[1:0] == 2'b00;
    assign memHalfwordAccess = funct3[1:0] == 2'b01;

    assign loadHalfWord = aluOut[1] ? memRdata[31:16] : memRdata[15:0];
    assign loadByte     = aluOut[0] ? loadHalfWord[15:8] : loadHalfWord[7:0];

    assign loadSign = !funct3[2] & (memByteAccess ? loadByte[7] : loadHalfWord[15]);

    assign loadData = memByteAccess     ? {{24{loadSign}}, loadByte} :
                      memHalfwordAccess ? {{16{loadSign}}, loadHalfWord} :
                      memRdata;

    // === Memory Write Data & Mask ===
    assign memWdata[7:0]   = rd2[7:0];
    assign memWdata[15:8]  = aluOut[0] ? rd2[7:0]   : rd2[15:8];
    assign memWdata[23:16] = aluOut[1] ? rd2[7:0]   : rd2[23:16];
    assign memWdata[31:24] = aluOut[0] ? rd2[7:0]   :
                             aluOut[1] ? rd2[15:8]  : rd2[31:24];

    assign memWmask = memByteAccess     ? (aluOut[1] ? (aluOut[0] ? 4'b1000 : 4'b0100) :
                                                         (aluOut[0] ? 4'b0010 : 4'b0001)) :
                      memHalfwordAccess ? (aluOut[1] ? 4'b1100 : 4'b0011) :
                                           4'b1111;

    // === ALU Inputs and PC Update ===
    assign aluin2pre = (isAlureg || isBranch) ? rd2 : (isStore ? Simm : Iimm);
    assign aluin2    = isShamt ? {27'b0, shamt} : aluin2pre;

    assign pcplusImm = pc + (instr[3] ? Jimm : instr[4] ? Uimm : Bimm);

    assign pcNext = (isBranch && !isZero || isJAL) ? pcplusImm :
                    isJALR ? {aluOut[31:1], 1'b0} :
                             pcplus4;

    assign wd3 = (isJAL || isJALR) ? pcplus4 :
                 isLUI            ? Uimm      :
                 isAUIPC          ? pcplusImm :
                 isLoad           ? loadData  :
                                     aluOut;

endmodule
