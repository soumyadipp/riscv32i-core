`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 03:57:37
// Design Name: 
// Module Name: aluDecode
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


module aluDecode(

   input logic [2:0] funct3,
   input logic [6:0] funct7,
   input logic instr_5, isBranch, isAlureg, isAluimm,
   output logic [3:0] aluCtrl,
   output logic isShamt

    );
    
    always_comb begin
    
    case({isBranch, isAlureg || isAluimm, funct3})
            5'b01000: aluCtrl <= (funct7[5] & instr_5) ? (4'h1) : (4'h0);
            5'b01001: aluCtrl <= 4'h2;
            5'b01010: aluCtrl <= 4'h3;
            5'b01011: aluCtrl <= 4'h4;
            5'b01100: aluCtrl <= 4'h5;
            5'b01101: aluCtrl <= funct7[5]? 4'h6 : 4'h7; 
            5'b01110: aluCtrl <= 4'h8;
            5'b01111: aluCtrl <= 4'h9;
            5'b10000: aluCtrl <= 4'ha;
            5'b10001: aluCtrl <= 4'hb;
            5'b10100: aluCtrl <= 4'h3;
            5'b10101: aluCtrl <= 4'hc;
            5'b10110: aluCtrl <= 4'h4;
            5'b10111: aluCtrl <= 4'hd;
            default: aluCtrl <= 4'h0;  // adder by default
        endcase
       
   case({isAlureg || isAluimm, funct3})
   4'b1001, 4'b1101 : isShamt <= 1'b1;
   default: isShamt <= 1'b0;
   endcase
     
     end 
  
endmodule
