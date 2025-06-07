`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 00:00:14
// Design Name: 
// Module Name: RISCV_TB
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


module RISCV_TB;

 logic clk, reset;
    logic [1:0] flag;
    logic [31:0] instr, memWdata, addr, pc, aluin1, aluin2, Simm, Jimm, Bimm, Iimm, memRdata;
    logic [4:0] rs1Id, rs2Id, rdId ;
    logic [3:0] memWMask, aluCtrll;
    logic isAlureg, 
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


RISCV dut (clk, reset, pc ,instr, memWdata, addr, aluin1, aluin2, Simm, Jimm, Bimm, Iimm, memRdata,rs1Id, rs2Id, rdId,
      memWmask, aluCtrl,isAlureg, regWrite, isJAL, isJALR, isBranch, isLUI, isAUIPC, isAluimm,isLoad, isStore, isShamt );


    initial begin
        flag = 0;
        reset = 1; #15; 
        reset = 0; #2;
    end

    always begin
        clk <= 1; #100;     
        clk <= 0; #100;     
    end

    always @(negedge clk) begin
        if (pc == 8'h44)
            flag = 1;
  
        if (flag == 2'b01)
        repeat(3) @(posedge clk)  $finish;
    end

endmodule
