`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Soumyadip Manna
// Design Name: Data Memory (DMem)
// Description: 256 x 32-bit memory with byte masking and debug read support
//////////////////////////////////////////////////////////////////////////////////

module DMem(
    input  logic        clk,
    input  logic [3:0]  memWmask,
    input  logic [31:0] a,     // Memory address
    input  logic [31:0] wd,    // Write data
    output logic [31:0] rd,
    
    input logic[31:0]debug_addr,
    output logic[31:0]debugdata_Dmem
);

    // === 256 x 32-bit RAM ===
    logic [31:0] RAM [0:255];

    // === Memory Write ===
    always_ff @(posedge clk) begin
        if (memWmask[0]) RAM[a[31:2]][7:0]   <= wd[7:0];
        if (memWmask[1]) RAM[a[31:2]][15:8]  <= wd[15:8];
        if (memWmask[2]) RAM[a[31:2]][23:16] <= wd[23:16];
        if (memWmask[3]) RAM[a[31:2]][31:24] <= wd[31:24];
    end

    // === Memory Read ===
    assign rd = RAM[a[31:2]];
    assign debugdata_Dmem = RAM[debug_addr[31:2]];
    // === Debug Read (read-only, parallel access) ===


endmodule
