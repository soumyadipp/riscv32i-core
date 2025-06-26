`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2025
// Design Name: 
// Module Name: slow_clk
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


// counts 1 second
module SlowClock #(parameter count)(
    input logic clk_in,
    input logic enable,
    output logic clk_out);
    
    logic [25:0] counter = 0;
    logic state = 0;
    
    always_ff @(posedge clk_in) begin
        counter <= counter + 1;
        if (counter == count - 1)
          begin
            counter <= 0;
            if (enable) state <= ~state;
          end
    end
    
    assign clk_out = state;
    
endmodule
