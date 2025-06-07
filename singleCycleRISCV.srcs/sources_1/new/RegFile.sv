`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 02:50:47
// Design Name: 
// Module Name: RegFile
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


module RegFile(

input logic clk,
input logic we3,
input logic [4:0] a1,a2,a3,
input logic [31:0] wd3,
output logic [31:0] rd1,rd2
   );
   
   logic [31:0] RegFile [31:0];
   
   always_ff @ (posedge clk)
   if(we3) RegFile[a3] <= wd3 ; // as x0 register is hardwired to zero
 
 assign rd1 = (a1 != 32'b0) ? RegFile[a1] : 32'b0;
 assign rd2 = (a2 != 32'b0) ? RegFile[a2] : 32'b0;  
   
endmodule
