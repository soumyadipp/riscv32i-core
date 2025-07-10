`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2025 05:42:50 PM
// Design Name: 
// Module Name: data_mem
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


module data_mem #(parameter DMEM_DEPTH = 8) (
    input logic clk, memW_en,
    input logic [31:0] data_in,
    input logic [31:0] addr,
    input logic [2:0] func3,
    output logic [31:0] data,
    
    
    ///debug signals
    
    input logic[31:0] debug_addr,
    output logic[31:0] debugmem_data
    );

    logic [31:0] d_mem [255:0];
    logic [31:2] word_addr;

    assign word_addr = addr[31:2];

  
    always_comb begin
        case(func3[1:0])
            2'b00: begin // load byte (signed/unsigned)
                case(addr[1:0])
                    2'b00: data = ~func3[2] ? {{24{d_mem[word_addr][7]}}, d_mem[word_addr][7:0]} : {24'b0, d_mem[word_addr][7:0]};
                    2'b01: data = ~func3[2] ? {{24{d_mem[word_addr][15]}}, d_mem[word_addr][15:8]} : {24'b0, d_mem[word_addr][15:8]};
                    2'b10: data = ~func3[2] ? {{24{d_mem[word_addr][23]}}, d_mem[word_addr][23:16]} : {24'b0, d_mem[word_addr][23:16]};
                    2'b11: data = ~func3[2] ? {{24{d_mem[word_addr][31]}}, d_mem[word_addr][31:24]} : {24'b0, d_mem[word_addr][31:24]};
                endcase
            end
            2'b01: begin // load half word (signed/unsigned)
                case(addr[1])
                    1'b0: data = ~func3[2] ? {{24{d_mem[word_addr][15]}}, d_mem[word_addr][15:0]} : {24'b0, d_mem[word_addr][15:0]};
                    1'b1: data = ~func3[2] ? {{24{d_mem[word_addr][31]}}, d_mem[word_addr][31:16]} : {24'b0, d_mem[word_addr][31:16]};
                endcase
            end
            default: data = d_mem[word_addr]; // load word
        endcase
    end

    always_ff @(negedge clk) begin
        if(memW_en) begin
            case(func3[1:0])
                2'b00: begin // load byte
                    case(addr[1:0])
                        2'b00: d_mem[word_addr][7:0] <= data_in[7:0];
                        2'b01: d_mem[word_addr][15:8] <= data_in[7:0];
                        2'b10: d_mem[word_addr][23:16] <= data_in[7:0];
                        2'b11: d_mem[word_addr][31:24] <= data_in[7:0];
                    endcase
                end
                2'b01: begin // load half word
                    case(addr[1])
                        1'b0: d_mem[word_addr][15:0] <= data_in[15:0];
                        1'b1: d_mem[word_addr][31:16] <= data_in[15:0];
                    endcase
                end
                default: d_mem[word_addr] <= data_in; // load word
            endcase
        end
    end
assign debugmem_data= d_mem[debug_addr[31:2]];
endmodule