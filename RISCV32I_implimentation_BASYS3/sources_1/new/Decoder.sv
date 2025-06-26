`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 04:16:58
// Design Name: 
// Module Name: Decoder
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


module Decoder(
input logic [31:0] instr,
output logic isAlureg, isAluimm, regWrite, isJAL, isJALR, isBranch, isLUI, isAUIPC,
output logic isLoad, isStore    
    
    );
    
    assign isAlureg =  (instr[6:0] == 7'b0110011); // rd <- rs1 OP rs2   
    assign isAluimm =  (instr[6:0] == 7'b0010011); // rd <- rs1 OP Iimm
    assign isBranch =  (instr[6:0] == 7'b1100011); // if(rs1 OP rs2) PC<-PC+Bimm
    assign isJALR   =  (instr[6:0] == 7'b1100111); // rd <- PC+4; PC<-rs1+Iimm
    assign isJAL    =  (instr[6:0] == 7'b1101111); // rd <- PC+4; PC<-PC+Jimm
    assign isAUIPC  =  (instr[6:0] == 7'b0010111); // rd <- PC + Uimm
    assign isLUI    =  (instr[6:0] == 7'b0110111); // rd <- Uimm   
    assign isLoad   =  (instr[6:0] == 7'b0000011); // rd <- mem[rs1+Iimm]
    assign isStore  =  (instr[6:0] == 7'b0100011); // mem[rs1+Simm] <- rs2
    assign regWrite = isAlureg || isAluimm || isLoad || isLUI || isAUIPC || isJAL || isJALR;
endmodule
