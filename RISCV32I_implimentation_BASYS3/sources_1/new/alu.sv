`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 03:03:01
// Design Name: 
// Module Name: alu
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
//| ALUControl |        Operation         | Related Mnemonic |
//| ---------- | ------------------------ | ---------------- |
//| 4'h0       | add                      | ADD, ADDI        |
//| 4'h1       | sub                      | SUB              |
//| 4'h2       | shift left               | SLL, SLLI        |
//| 4'h3       | signed less than         | SLT, BLT         |
//| 4'h4       | unsigned less than       | SLTU, BLTU       |
//| 4'h5       | xor                      | XOR, XORI        |
//| 4'h6       | signed shift right       | SRA, SRAI        |
//| 4'h7       | logical shift right      | SRL, SRLI        |
//| 4'h8       | or                       | OR, ORI          |
//| 4'h9       | and                      | AND, ANDI        |
//| 4'hA       | equal comparison         | BEQ              |
//| 4'hB       | not equal                | BNE              |
//| 4'hC       | greater/equal (signed)   | BGE              |
//| 4'hD       | greater/equal (unsigned) | BGEU             |


module alu(
  
  input logic [3:0] aluCtrl,
  input logic [31:0] op1, op2,
  output logic [31:0] aluOut,
  output logic isZero

    );
    
    always_comb begin 
       case(aluCtrl)
            4'h0: aluOut <= op1 + op2;
            4'h1: aluOut <= op1 - op2;
            4'h2: aluOut <= op1 << op2;
            4'h3: aluOut <= $signed(op1) < $signed(op2);
            4'h4: aluOut <= op1 < op2;
            4'h5: aluOut <= op1 ^ op2;
            4'h6: aluOut <= $signed(op1) >>> op2;
            4'h7: aluOut <= op1 >> op2;
            4'h8: aluOut <= op1 | op2;
            4'h9: aluOut <= op1 & op2;
            4'ha: aluOut <= op1 == op2;
            4'hb: aluOut <= op1 != op2;
            4'hc: aluOut <= $signed(op1) >= $signed(op2);
            4'hd: aluOut <= op1 >= op2;
            default: aluOut <= 31'b0;
        endcase
    end
    
    assign isZero = ~|aluOut;
    
    
endmodule
