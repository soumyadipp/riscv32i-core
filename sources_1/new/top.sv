`timescale 1ns / 1ps

module RiscVTop(
   input logic clk, reset, clkEnable,BTNU,BTND,BTNR,BTNL,BTNC,
   output logic [6:0] led_segment,
   output logic [3:0] anode_activate,
   output logic slow_clk, dp,scroll,op     
);
    logic [31:0] debug_addr,debugdata_Reg,debugdata_Dmem;
    logic [31:0] pc, instr, memWdata, addr, aluIn1, aluIn2, Simm, Jimm, Bimm, Iimm, memRdata;
    logic [4:0] rs1Id, rs2Id, rdId;
    logic [3:0] memWMask, aluControl;
    logic isALUreg, 
        regWrite,
        isJAL,
        isJALR,
        isBranch,
        isLUI,
        isAUIPC,
        isALUimm,
        isLoad, 
        isStore,
        isShamt;

    logic [15:0] displayed_number,value;
    logic scroll_clk;
    logic db_BTNC, db_BTNU, db_BTND, db_BTNL, db_BTNR;
    debounce db0(.clk(scroll_clk), .btn_in(BTNC), .btn_out(db_BTNC));
    debounce db1(.clk(scroll_clk), .btn_in(BTNU), .btn_out(db_BTNU));
    debounce db2(.clk(scroll_clk), .btn_in(BTND), .btn_out(db_BTND));
    debounce db3(.clk(scroll_clk), .btn_in(BTNL), .btn_out(db_BTNL));
    debounce db4(.clk(scroll_clk), .btn_in(BTNR), .btn_out(db_BTNR));

    SlowClock #(50000000)slowClock1(clk, (reset|(~op & clkEnable)), slow_clk);
    SlowClock #(10000000)slowClock2(clk,~clkEnable,scroll_clk);
    SevenSegmentTop sevenSegmentTop(
        .clk(clk),
        .displayed_number(displayed_number),
        .led_segment(led_segment),
        .anode_activate(anode_activate),
        .dp(dp));

    RISCV riscv(slow_clk, reset,debug_addr, pc, instr, memWdata, addr, aluIn1, aluIn2, Simm, Jimm, Bimm, Iimm, memRdata, rs1Id, rs2Id, rdId, memWMask, aluControl,
        isALUreg, 
        regWrite,
        isJAL,
        isJALR,
        isBranch,
        isLUI,
        isAUIPC,
        isALUimm,
        isLoad, 
        isStore,
        isShamt,
        debugdata_Dmem,
        debugdata_Reg
    );
    
    
    logic m_r;
    logic[15:0] displayed_value_scroll;
    scroll_menu scrollMenu(
        .scroll_clk(scroll_clk),
        .clkEnable(clkEnable),
        .BNTC(db_BTNC),
        .BNTU(db_BTNU),
        .BNTD(db_BTND),
        .BNTL(db_BTNL),
        .BNTR(db_BTNR),
        .debugdata_Dmem(debugdata_Dmem),
        .debugdata_Reg(debugdata_Reg),
        .debug_addr(debug_addr),
        .display_Value_scroll(displayed_value_scroll)
    );


assign displayed_number = clkEnable ? op? 32'h0EB0 : pc[15:0]:displayed_value_scroll;
assign  op = (instr == 32'h0010_0073) ? 1'b1 : 1'b0; // if encounter EBRAKE it stop the cpu
assign scroll= clkEnable;
endmodule
