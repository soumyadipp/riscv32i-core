`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 20:57:45
// Design Name: 
// Module Name: RISCV
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


module RISCV(

  input logic clk, reset,
  output logic [31:0] pc ,instr, memWdata, addr, aluin1, aluin2, Simm, Jimm, Bimm, Iimm, memRdata,
  output logic [4:0] rs1Id, rs2Id, rdId,
  output logic [3:0] memWmask, aluCtrl,
  output logic isAlureg, regWrite, isJAL, isJALR, isBranch, isLUI, isAUIPC, isAluimm,isLoad, isStore, isShamt

    );
    
    logic [2:0] funct3;
    logic [6:0] funct7;
    
    logic isZero;
    
    Decoder decode1 (instr,isAlureg, isAluimm, regWrite, isJAL, isJALR, isBranch, isLUI, isAUIPC,isLoad, isStore);
    
    
    aluDecode aludecode1 (funct3,funct7,instr[5], isBranch, isAlureg, isAluimm,aluCtrl,isShamt);
    
    
    dataPath path1 (clk, reset,isAlureg, regWrite, isJAL, isJALR, isBranch, isLUI, isAUIPC, isLoad, isStore, isShamt,funct3,aluCtrl,
             instr, memRdata,pc, addr, memWdata, aluin1, aluin2, Simm, Bimm, Jimm, Iimm,rs1Id, rs2Id, rdId, memWmask,isZero );
             
 
dist_mem_gen_0 imem_1 (.a(pc[9:2]),.spo(instr));
     DMem dmem1 (clk,{{4{isStore}} & memWmask}, addr, memWdata,memRdata);   
  
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];
             
endmodule
