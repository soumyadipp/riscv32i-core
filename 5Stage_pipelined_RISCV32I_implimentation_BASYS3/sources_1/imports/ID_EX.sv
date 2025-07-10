`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2025 11:04:04 AM
// Design Name: 
// Module Name: ID_EX
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


module ID_EX #(parameter IMEM_DEPTH = 512) (
    input clk, rst, en, flush,

    input logic [31:0] pc_curr_ID,
    input logic [31:0] rs1_ID,
    input logic [31:0] rs2_ID,
    input logic [31:0] imm_ex_out_ID,
    input logic [31:0] inst_ID,

    output logic [31:0] pc_curr_EX,
    output logic [31:0] rs1_EX,
    output logic [31:0] rs2_EX,
    output logic [31:0] imm_ex_out_EX,
    output logic [31:0] inst_EX,

    // control signals
    input logic [2:0] func3_ID,
    input logic [3:0] ALUsel_ID,
    input logic [1:0] WBsel_ID,
    input logic regW_en_ID, Bsel_ID, memW_en_ID, jump_ID, Asel_ID,

    output logic [2:0] func3_EX,
    output logic [3:0] ALUsel_EX,
    output logic [1:0] WBsel_EX,
    output logic regW_en_EX, Bsel_EX, memW_en_EX, jump_EX, Asel_EX
    );

    always_ff @( posedge clk or posedge rst ) begin
        if(rst || flush) begin
            pc_curr_EX <= 0;
            rs1_EX <= 0;
            rs2_EX <= 0;
            imm_ex_out_EX <= 0;
            inst_EX <= 32'h00000013;

            jump_EX <= 0;
            regW_en_EX <= 0;
            func3_EX <= 0;
            ALUsel_EX <= 0;
            WBsel_EX <= 1;
            Bsel_EX <= 0;
            memW_en_EX <= 0;
            Asel_EX <= 0;
        end else if (en) begin
            pc_curr_EX <= pc_curr_ID;
            rs1_EX <= rs1_ID;
            rs2_EX <= rs2_ID;
            imm_ex_out_EX <= imm_ex_out_ID;
            inst_EX <= inst_ID;

            jump_EX <= jump_ID;
            regW_en_EX <= regW_en_ID;
            func3_EX <= func3_ID;
            ALUsel_EX <= ALUsel_ID;
            WBsel_EX <= WBsel_ID;
            Bsel_EX <= Bsel_ID;
            memW_en_EX <= memW_en_ID;
            Asel_EX <= Asel_ID;
        end
    end

endmodule
