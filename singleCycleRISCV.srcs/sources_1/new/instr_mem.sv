`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 01:55:58
// Design Name: 
// Module Name: instr_mem
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


module instr_mem(

    input logic [7:0] a,
    output logic [31:0] rd

    );
    
    
    logic [31:0] ROM [255:0];
    
    initial
    $readmemh ("instr.mem", ROM);
    
    assign rd = ROM[a];
endmodule



