`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2025 11:05:52 AM
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM #(parameter IMEM_DEPTH = 512) (
    input clk, rst, en, flush,

    input logic [31:0] pc_curr_EX,
    input logic [31:0] ALUout_EX,
    input logic [31:0] rs2_EX,
    input logic [31:0] inst_EX,

    input logic [2:0] func3_EX,
    input logic [1:0] WBsel_EX,
    input logic regW_en_EX, memW_en_EX, jump_EX, valid_branch_EX,

    output logic [31:0] pc_curr_MEM,
    output logic [31:0] ALUout_MEM,
    output logic [31:0] rs2_MEM,
    output logic [31:0] inst_MEM,

    output logic [2:0] func3_MEM,
    output logic [1:0] WBsel_MEM,
    output logic regW_en_MEM, memW_en_MEM, jump_MEM, valid_branch_MEM
    );

    always_ff @(posedge clk or posedge rst) begin
        if(rst || flush) begin
            pc_curr_MEM <= 0;
            ALUout_MEM <= 0;
            rs2_MEM <= 0;
            inst_MEM <= 32'h00000013;

            func3_MEM <= 0;
            WBsel_MEM <= 1;
            regW_en_MEM <= 0;
            memW_en_MEM <= 0;
            jump_MEM <= 0;
            valid_branch_MEM <= 0;
        end else if (en) begin
            pc_curr_MEM <= pc_curr_EX;
            ALUout_MEM <= ALUout_EX;
            rs2_MEM <= rs2_EX;
            inst_MEM <= inst_EX;

            func3_MEM <= func3_EX;
            WBsel_MEM <= WBsel_EX;
            regW_en_MEM <= regW_en_EX;
            memW_en_MEM <= memW_en_EX;
            jump_MEM <= jump_EX;
            valid_branch_MEM <= valid_branch_EX;
        end
    end

endmodule
