`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2025 03:03:01
// Design Name: 
// Module Name: scroll menu
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


module scroll_menu(
    input  logic        scroll_clk,
    input  logic        clkEnable,
    input  logic        BNTC, BNTU, BNTD, BNTL, BNTR,
    input  logic [31:0] debugdata_Dmem,
    input  logic [31:0] debugdata_Reg,
    output logic [31:0] debug_addr,
    output logic [15:0] display_Value_scroll,
    output logic        m_r  // 1 = Memory, 0 = Register
);

    logic [7:0] addr_index;  // For memory mode: 0-255, register mode: only 0-31
    logic       show_data;   // 0 = show address, 1 = show content

    always_ff @(posedge scroll_clk) begin
        if (~clkEnable) begin
            // Scroll up
            if (BNTU) begin
                if (m_r && addr_index < 8'd255)
                    addr_index <= addr_index + 1;
                else if (~m_r && addr_index < 8'd31)
                    addr_index <= addr_index + 1;
            end
            // Scroll down
            else if (BNTD) begin
                if (addr_index > 0)
                    addr_index <= addr_index - 1;
                    
                else if(addr_index == 0) begin
                    if(m_r)
                    addr_index <= 8'd255;
                   else addr_index <= 8'd31;
                  end     
            end

            // Mode switch
            if (BNTR) begin
                m_r <= 1;          // Memory mode
                addr_index <= 0;   // Reset index
                show_data <= 0;
            end else if (BNTL) begin
                m_r <= 0;          // Register mode
                addr_index <= 0;
                show_data <= 0;
            end

            // Toggle view between address and data
            if (BNTC)
                show_data <= ~show_data;
        end
    end

    // Generate debug address
    always_comb begin
        if (m_r)
            debug_addr = {addr_index, 2'b00};  // Memory address * 4
        else
            debug_addr = addr_index;          // Register address
    end

    // Generate display value
    always_comb begin
        if (~clkEnable) begin
            if (show_data) begin
                display_Value_scroll = m_r ? debugdata_Dmem[15:0] : debugdata_Reg[15:0];
            end else begin
                display_Value_scroll = { (m_r ? 8'hAD : 8'hAE), addr_index };

            end
        end else begin
            display_Value_scroll = 16'h0000;
        end
    end

endmodule
