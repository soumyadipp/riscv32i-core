`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2025 11:07:00 AM
// Design Name: 
// Module Name: branch_comp
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


module branch_comp(
    input logic signed [31:0] A,
    input logic signed [31:0] B,
    input logic [6:0] opcode, // to check if branch instruction
    input logic [2:0] func3,
    output logic valid_branch
    );

    logic Eq, Lt;

    // func3[1] : unsigned or signed
    assign Eq = (A==B) ? 1'b1 : 1'b0;
    assign Lt = func3[1] ? ((unsigned'(A) < unsigned'(B) ? 1'b1 : 1'b0)) : ((A < B) ? 1'b1 : 1'b0);
    always_comb begin
        case({func3[2], func3[0]}) // to check which branch instruction
            2'b00: valid_branch = (opcode == 7'b1100011) ? (Eq ? 1'b1 : 1'b0) : 1'b0;
            2'b01: valid_branch = (opcode == 7'b1100011) ? (Eq ? 1'b0 : 1'b1) : 1'b0;
            2'b10: valid_branch = (opcode == 7'b1100011) ? (Lt ? 1'b1 : 1'b0) : 1'b0;
            2'b11: valid_branch = (opcode == 7'b1100011) ? (Lt ? 1'b0 : 1'b1) : 1'b0;
        endcase
    end

endmodule
