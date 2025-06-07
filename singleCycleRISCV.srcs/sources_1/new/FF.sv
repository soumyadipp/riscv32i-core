`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 04:13:21
// Design Name: 
// Module Name: FF
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


module FF(

 input logic clk,reset,
 input logic [31:0] d,
 output logic [31:0] q
    );
    
    always_ff @(posedge clk)
     if (reset)
      q <= 32'b0;
      
    else 
      q <= d;
      
       
    
endmodule
