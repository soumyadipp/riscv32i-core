`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2025 12:01:39 PM
// Design Name: 
// Module Name: alu_logic
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


module alu_logic(
    input logic signed [31:0] data1,
    input logic signed [31:0] data2,
    input logic [3:0] ALUsel, // func3 = ALUsel[2:0], func7[5] = ALUsel[3]
    output logic [31:0] ALUout
    );

    logic [31:0] temp1;
    logic [31:0] temp2;

    assign temp1 = data1;
    assign temp2 = data2;

    always_comb begin
        case(ALUsel[2:0])
            3'b000: ALUout = ALUsel[3] ? data1 - data2 : data1 + data2;             // sub/add
            3'b001: ALUout = ALUsel[3] ? data2 : data1 << data2[4:0];               // bypass data2 (for lui) / sll
            3'b010: ALUout = (data1 < data2) ? 1 : 0;                               // slt
            3'b011: ALUout = (temp1 < temp2) ? 1 : 0;                               // sltu
            3'b100: ALUout = data1 ^ data2;                                         // xor
            3'b101: ALUout = ALUsel[3] ? data1 >>> data2[4:0] : data1 >> data2[4:0];// sra/srl
            3'b110: ALUout = data1 | data2;                                         // or
            3'b111: ALUout = data1 & data2;                                         // and
            default: ALUout = 32'h00000000;
        endcase
    end
endmodule
