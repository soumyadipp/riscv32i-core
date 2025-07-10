`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2025 12:04:31 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb;

    logic clk, rst;
    logic [31:0] inst_WB;
    logic [31:0] ALUout;
    logic [31:0] debug_addr;
    logic[31:0] debugmem_data,debugreg_data;
    logic[31:0] pc_curr;
    top uut (.*);

    always #5 clk = ~clk;

    initial begin
        clk = 1; rst = 1;
        #10
        rst = 0;
        
        wait(inst_WB ==32'h00100073) #5 $stop;
    end

endmodule
