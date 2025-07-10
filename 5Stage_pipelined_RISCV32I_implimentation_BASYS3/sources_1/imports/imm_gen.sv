`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2025 12:01:39 PM
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input logic [31:0] inst,
    output logic [31:0] imm_ex
    );

    always_comb begin
        case(inst[6:2])
            5'b11011: imm_ex = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], {1'b0}}; // jal
            5'b00100: imm_ex = {{20{inst[31]}}, inst[31:20]}; // load
            5'b11001: imm_ex = {{20{inst[31]}}, inst[31:20]}; // jalr
            5'b00000: imm_ex = {{20{inst[31]}}, inst[31:20]}; // ir-type
            5'b01000: imm_ex = {{20{inst[31]}}, inst[31:25], inst[11:7]}; // store
            5'b11000: imm_ex = {{21{inst[31]}}, inst[7], inst[30:25], inst[11:8], {1'b0}}; // branch
            5'b01101: imm_ex = {inst[31:12], {12'b0}}; // lui
            5'b00101: imm_ex = {inst[31:12], {12'b0}}; // auipc
            default: imm_ex = 32'bx;
        endcase
    end

endmodule

