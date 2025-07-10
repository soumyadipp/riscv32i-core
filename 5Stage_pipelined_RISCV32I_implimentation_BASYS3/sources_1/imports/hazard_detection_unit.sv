`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2025 02:04:00 PM
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit(
    
    input logic [31:0] inst_ID,
    input logic [31:0] inst_EX,
    input logic [31:0] inst_MEM,
    input logic [31:0] inst_WB,

    input logic regW_en_MEM, regW_en_WB, load_pc,
    input logic [1:0] WBsel_EX,

    output logic [1:0] fwd_A,
    output logic [1:0] fwd_B,
    output logic pc_en, IF_ID_en, ID_EX_en,

    output logic IF_ID_flush,
    output logic ID_EX_flush,
    output logic EX_MEM_flush
    );

    logic [4:0] rs1_ID;
    logic [4:0] rs2_ID;

    logic [4:0] rs1_EX;
    logic [4:0] rs2_EX;

    logic [4:0] rsW_EX;
    logic [4:0] rsW_WB;
    logic [4:0] rsW_MEM;

    assign rs1_ID = inst_ID[19:15];
    assign rs2_ID = inst_ID[24:20];

    assign rs1_EX = inst_EX[19:15];
    assign rs2_EX = inst_EX[24:20];

    assign rsW_EX = inst_EX[11:7];
    assign rsW_WB = inst_WB[11:7];
    assign rsW_MEM = inst_MEM[11:7];

    // forwarding unit
    always_comb begin
            // rs1(i) == rsW(i-1) && regW_en(i-1) == 1 && rs1 != 0
        if((rsW_MEM == rs1_EX) && regW_en_MEM && rsW_MEM) fwd_A = 2'b01;
            // rsW(i) == rs1(i-2) && regW_en(i-2) == 1 && rs1 != 0
        else if ((rsW_WB == rs1_EX) && regW_en_WB && rsW_WB) fwd_A = 2'b10;
        else fwd_A = 2'b00;

            // rsW(i) == rs2(i-1) && regW_en(i-1) == 1 && rs2 != 0
        if((rsW_MEM == rs2_EX) && regW_en_MEM && rsW_MEM) fwd_B = 2'b01;
            // rsW(i) == rs2(i-2) && regW_en(i-2) == 1 && rs2 != 0
        else if ((rsW_WB == rs2_EX) && regW_en_WB && rsW_WB) fwd_B = 2'b10;
        else fwd_B = 2'b00;
    end

    // stalling and flushing unit
    always_comb begin

        // flush for branch and jump
        if(load_pc) begin
            IF_ID_flush = 1;
            EX_MEM_flush = 1;
        end else begin
            IF_ID_flush = 0;
            EX_MEM_flush = 0;
        end

        // stall for load
        if(!WBsel_EX && ((rsW_EX==rs1_ID) || (rsW_EX==rs2_ID))) begin
            pc_en = 0;
            IF_ID_en = 0;
            ID_EX_en = 0;
        end else begin
            pc_en = 1;
            IF_ID_en = 1;
            ID_EX_en = 1;
        end

        if(load_pc || (!WBsel_EX && ((rsW_EX==rs1_ID) || (rsW_EX==rs2_ID))))
            ID_EX_flush = 1;
        else
            ID_EX_flush = 0;

    end

endmodule
