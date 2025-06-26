module RegFile(
    input  logic        clk,
    input  logic        we3,
    input  logic [4:0]  a1, a2, a3,
    input  logic [31:0] wd3,
    input logic [31:0] debug_addr,
    output logic [31:0] rd1, rd2,
    output logic [31:0] debugdata_Reg
);

    logic [31:0] RegFile [31:0];

    // Write operation
    always_ff @(posedge clk) begin
        if (we3 && (a3 != 5'd0))
            RegFile[a3] <= wd3;
    end

    // Read operation
    assign rd1 = (a1 != 5'd0) ? RegFile[a1] : 32'd0;
    assign rd2 = (a2 != 5'd0) ? RegFile[a2] : 32'd0;
    assign debugdata_Reg = (debug_addr[4:0] != 5'd0)?RegFile[debug_addr[4:0]]:32'd0;


endmodule
