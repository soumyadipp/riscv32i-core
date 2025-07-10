`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2025 12:01:39 PM
// Design Name: 
// Module Name: inst_mem
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


module inst_mem #(parameter IMEM_DEPTH = 256)(
    input logic [31:0] addr,
    output logic [31:0] data
    );

  
    logic [7:0] word_addr;

    assign word_addr = addr[9:2];

    


dist_mem_gen_0 IMEM (
  .a(word_addr),      // input wire [5 : 0] a
  .spo(data)  // output wire [31 : 0] spo
);


endmodule