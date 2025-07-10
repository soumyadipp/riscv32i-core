`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2025 11:06:42 AM
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB #(parameter IMEM_DEPTH = 512) (
    input clk, rst, en,

    input logic [31:0] pc_next_MEM,
    input logic [31:0] ALUout_MEM,
    input logic [31:0] d_mem_out_MEM,
    input logic [31:0] inst_MEM,

    input logic [1:0] WBsel_MEM,
    input logic regW_en_MEM, jump_MEM,

    output logic [31:0] pc_next_WB,
    output logic [31:0] ALUout_WB,
    output logic [31:0] d_mem_out_WB,
    output logic [31:0] inst_WB,

    output logic [1:0] WBsel_WB,
    output logic regW_en_WB
    );

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            pc_next_WB <= 0;
            ALUout_WB <= 0;
            d_mem_out_WB <= 0;
            inst_WB <= 32'h00000013;

            WBsel_WB <= 1;
            regW_en_WB <= 0;
        end else if (en) begin
            pc_next_WB <= pc_next_MEM;
            ALUout_WB <= ALUout_MEM;
            d_mem_out_WB <= d_mem_out_MEM;
            inst_WB <= inst_MEM;

            WBsel_WB <= WBsel_MEM;
            regW_en_WB <= regW_en_MEM;
        end
    end
endmodule
