`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2025 02:20:01 PM
// Design Name: 
// Module Name: control
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


module control(
    input logic [31:0] instruction,
    output logic [2:0] func3,
    output logic [3:0] ALUsel,
    output logic [1:0] WBsel,
    output logic regW_en, Bsel, memW_en, jump, Asel, BrUn
    );

    logic func7_5;
    logic [6:0] opcode;
    
    assign func3 = instruction[14:12];
    assign func7_5 = instruction[30];
    assign opcode = instruction[6:0];

    always_comb begin
        case(opcode)
            // r-type
            7'b0110011: begin
                regW_en = 1'b1;
                Bsel = 1'b0;
                ALUsel = {func7_5, func3};
                WBsel = 1;
                memW_en = 1'b0; // <<-- unchecked in tb
                jump = 1'b0;
                Asel = 1'b0;
            end
            // i-rtype
            7'b0010011: begin
                regW_en = 1'b1;
                Bsel = 1'b1;
                // addi x1, x0, -4 <--- !!! done
                ALUsel = (func3) ? {func7_5, func3} : {1'b0, func3};
                WBsel = 1;
                memW_en = 1'b0; // <<-- unchecked in tb
                jump = 1'b0;
                Asel = 1'b0;
            end
            // load
            7'b0000011: begin
                regW_en = 1'b1; // write to reg
                Bsel = 1'b1; // select imm
                ALUsel = 4'b0000; // add
                WBsel = 0; // read from dmem
                memW_en = 1'b0; // <<-- unchecked in tb
                jump = 1'b0;
                Asel = 1'b0;
            end
            // store
            7'b0100011: begin
                regW_en = 1'b0; // write to reg
                Bsel = 1'b1; // select imm
                ALUsel = 4'b0000; // add
                WBsel = 1; // this should not be zero --- for lw data hazard
                memW_en = 1'b1; // <<-- unchecked in tb
                jump = 1'b0;
                Asel = 1'b0;
            end
            // jal
            7'b1101111: begin
                regW_en = 1'b1;
                Bsel = 1'b1;
                ALUsel = 4'b0000; // add pc+imm
                WBsel = 2; // read pc+4
                memW_en = 1'b0; // <<-- unchecked in tb
                jump = 1'b1;
                Asel = 1'b1; // sel pc as alu input
            end
            // jalr
            7'b1100111: begin
                regW_en = 1'b1;
                Bsel = 1'b1;
                ALUsel = 4'b0000; // add rs1+imm
                WBsel = 2; // read pc+4
                memW_en = 1'b0; // <<-- unchecked in tb
                jump = 1'b1;
                Asel = 1'b0; // sel rs1 as alu input (Asel)
            end
            // branch
            7'b1100011: begin
                regW_en = 1'b0; // don't write back
                Bsel = 1'b1; // select imm
                ALUsel = 4'b0000; // add rs1+imm
                WBsel = 2; // read pc+4 (dont care)?
                memW_en = 1'b0; // <<-- unchecked in tb
                jump = 1'b0;
                Asel = 1'b1; // sel pc as alu input (Asel)
            end
            // lui
            7'b0110111: begin
                regW_en = 1'b1; // write back to reg
                Bsel = 1'b1; // select imm
                ALUsel = 4'b1001; // bypass alu (data2)
                WBsel = 1; // read ALUout
                memW_en = 1'b0; // <<-- unchecked in tb
                jump = 1'b0; // don't load pc
                Asel = 1'b1; // data1 sel (dont care?)
            end
            // auipc
            7'b0010111: begin
                regW_en = 1'b1; // write back to reg
                Bsel = 1'b1; // select imm
                ALUsel = 4'b0000; // add imm + pc_curr
                WBsel = 1; // read ALUout
                memW_en = 1'b0; // <<-- unchecked in tb
                jump = 1'b0; // don't load pc
                Asel = 1'b1; // pc_curr value
            end
            default: begin
                // add x0 x0 x0
                regW_en = 1'b0; 
                Bsel = 1'b0;
                ALUsel = 4'b0000;
                WBsel = 1; // read from dmem
                memW_en = 1'b0; // <<-- unchecked in tb
                jump = 1'b0;
                Asel = 1'b0;
            end
        endcase
    end

endmodule
