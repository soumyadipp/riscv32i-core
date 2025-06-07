`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 02:14:06
// Design Name: 
// Module Name: DMem
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


module DMem(

 input logic clk,
 input logic [3:0] memWmask,
 input logic [31:0] a, wd,
 output logic [31:0] rd

    );
    
    logic [31:0] RAM [255:0] ;
    
    always_ff @(posedge clk) begin
    
 if(memWmask[0]) RAM[a[31:2]][7:0] <= wd[7:0];
 if(memWmask[1]) RAM[a[31:2]][15:8] <= wd[15:8];   
 if(memWmask[2]) RAM[a[31:2]][23:16] <= wd[23:16];   
 if(memWmask[3]) RAM[a[31:2]][31:24] <= wd[31:24];   
end

assign rd = RAM[a[31:2]];

endmodule
