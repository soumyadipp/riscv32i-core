`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2025 11:03:15 AM
// Design Name: 
// Module Name: IF_ID
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


module IF_ID #(parameter IMEM_DEPTH = 512) (
    input logic clk, rst, en, flush,

    input logic [31:0] pc_curr_IF,
    input logic [31:0] inst_IF,

    output logic [31:0] pc_curr_ID,
    output logic [31:0] inst_ID
    );

    always_ff @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            pc_curr_ID <= 0;
            inst_ID <= 32'h00000013;
        end else if (en) begin
            pc_curr_ID <= pc_curr_IF;
            inst_ID <= inst_IF;
        end
    end
endmodule
