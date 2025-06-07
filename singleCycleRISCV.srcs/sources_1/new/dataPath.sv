`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 04:39:12
// Design Name: 
// Module Name: dataPath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dataPath(

 input logic clk, reset,
 input logic isAlureg, regWrite, isJAL, isJALR, isBranch, isLUI, isAUIPC, isLoad, isStore, isShamt,
 input logic [2:0] funct3,
 input logic [3:0] aluCtrl,
 input logic [31:0] instr, memRdata,
 output logic [31:0] pc, aluOut, memWdata, aluin1, aluin2, Simm, Bimm, Jimm, Iimm,
 output logic [4:0] rs1Id, rs2Id, rdId,
 output logic [3:0] memWmask,
 output logic isZero

    );
    logic [31:0] pcNext, pcplus4,rd2,aluin2pre,pcplusImm,wd3,loadData;
    logic[ 1:0] memByteAccess, memHalfwordAccess;
    logic [15:0] loadHalfWord;
    logic [7:0] loadByte;
    logic loadSign;
    logic [31:0] Uimm;
    logic [4:0] shamt;
    
    FF FF1 (.clk(clk),.reset(reset),.d(pcNext),.q(pc));
    adder Adder1 ( .ip1(pc), .ip2(32'b100), .op(pcplus4));
    RegFile Reg1(.clk(clk),.we3(regWrite),.a1(rs1Id),.a2(rs2Id),.a3(rdId),.wd3(wd3),.rd1(aluin1),.rd2(rd2));
    alu ALU1(.aluCtrl(aluCtrl),.op1(aluin1), .op2(aluin2),.aluOut(aluOut),.isZero(isZero));
 
 assign memByteAccess = funct3[1:0] == 2'b00;
 assign memHalfwordAccess = funct3[1:0] == 2'b01;
 assign loadHalfWord = aluOut[1] ? memRdata[31:16] : memRdata[15:0];
 assign loadByte = aluOut[0] ? loadHalfWord[15:8] : loadHalfWord[7:0];
 assign loadData = memByteAccess ? {{24{loadSign}}, loadByte} : memHalfwordAccess ? {{16{loadSign}}, loadHalfWord} : memRdata;  
 assign memWdata[ 7: 0] = rd2[7:0];
 assign memWdata[15: 8] = aluOut[0] ? rd2[7:0]  : rd2[15: 8];
 assign memWdata[23:16] = aluOut[1] ? rd2[7:0]  : rd2[23:16];
 assign memWdata[31:24] = aluOut[0] ? rd2[7:0]  : aluOut[1] ? rd2[15:8] : rd2[31:24];
 assign memWmask = memByteAccess ? (aluOut[1] ? (aluOut[0] ? 4'b1000 : 4'b0100) : (aluOut[0] ? 4'b0010 : 4'b0001)) : memHalfwordAccess ?(aluOut[1] ? 4'b1100 : 4'b0011) : 4'b1111;
 assign pcplusImm = pc + (instr[3] ? Jimm[31:0] : instr[4] ? Uimm[31:0] : Bimm[31:0]);  
 assign aluin2pre =  (isAlureg | isBranch) ? rd2 :isStore ? Simm :Iimm;
 assign aluin2 = isShamt ?{27'b0 , shamt} : aluin2pre;
 assign pcNext = (isBranch && !isZero || isJAL) ? pcplusImm :isJALR ? {aluOut[31:1],1'b0}:pcplus4;
 assign wd3 = (isJAL || isJALR) ? pcplus4 :isLUI ? Uimm :isAUIPC ? pcplusImm :isLoad ? loadData :aluOut;

  assign rs1Id = instr[19:15];
  assign rs2Id = instr[24:20];
  assign rdId  = instr[11:7];

  assign Uimm = {instr[31], instr[30:12], {12{1'b0}}};
  assign Iimm = {{21{instr[31]}}, instr[30:20]};
  assign Simm = {{21{instr[31]}}, instr[30:25],instr[11:7]};
  assign Bimm = {{20{instr[31]}}, instr[7],instr[30:25],instr[11:8],1'b0};
  assign Jimm = {{12{instr[31]}}, instr[19:12],instr[20],instr[30:21],1'b0};

  assign shamt = isAlureg ? rd2[4:0] : instr[24:20];
  assign loadSign = !funct3[2] & (memByteAccess ? loadByte[7] : loadHalfWord[15]);


endmodule
