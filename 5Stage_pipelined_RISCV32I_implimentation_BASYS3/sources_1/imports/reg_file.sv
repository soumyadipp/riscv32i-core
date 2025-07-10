`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2025 12:01:39 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input logic clk,
    input logic rst,
    input logic [31:0] dataW,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rsW,
    input logic regW_en,
    output logic [31:0] data1,
    output logic [31:0] data2,
    
    ///debug signals
    
    input logic[31:0] debug_addr,
    output logic[31:0] debugreg_data
    
    );

    logic [31:0] registers [31:0];
    
    always_ff@(negedge clk or posedge rst) begin
        if (rst) foreach(registers[i]) registers[i] <= 32'h00000000;
        else if(regW_en) registers[rsW] <= dataW;
    end

    always_comb begin
        data1 <= rs1 ? registers[rs1] : 32'h00000000;
        data2 <= rs2 ? registers[rs2] : 32'h00000000;
    end
    assign debugreg_data =debug_addr[4:0]? registers[debug_addr[4:0]]:32'h00000000;
    
endmodule
