`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2025 12:02:03 PM
// Design Name: 
// Module Name: top
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


module top(
    input logic clk, rst,
    output logic [31:0] inst_WB,
    output logic [31:0] ALUout,
    output logic [31:0] pc_curr,
    
    ///debug signals
    input logic[31:0] debug_addr,
    output logic[31:0] debugmem_data,
    output logic[31:0] debugreg_data
    
    );

    localparam IMEM_DEPTH = 256;
    localparam DMEM_DEPTH = 256;

    logic [31:0] data1_out;
    logic [31:0] data2_out;
    logic [31:0] imm_ex_out;
    logic [31:0] d_mem_out;
    logic [31:0] ALUd1_in;
    logic [31:0] ALUd2_in;
    logic [31:0] regD_in;

    // pc depends on imem depth
  
    // logic [$clog2(IMEM_DEPTH)-1:0] pc_next; // not needed now

    // control signals
    logic [3:0] ALUsel;
    logic [2:0] func3;
    logic [1:0] WBsel;
    logic regW_en, Bsel, memW_en, load_pc, Asel, jump, valid_branch;

    // ID signals
    logic [31:0] pc_curr_ID;
    logic [31:0] inst_ID;

    // EX signals
    logic [31:0] pc_curr_EX;
    logic [31:0] rs1_EX;
    logic [31:0] rs2_EX;
    logic [31:0] imm_ex_out_EX;
    logic [31:0] inst_EX;
        //
    logic [2:0] func3_EX;
    logic [3:0] ALUsel_EX;
    logic [1:0] WBsel_EX;
    logic regW_en_EX, Bsel_EX, memW_en_EX, jump_EX, Asel_EX;

    // MEM signals
    logic [31:0] pc_curr_MEM;
    logic [31:0] pc_next_MEM; // output of adder in MEM stage !
    logic [31:0] ALUout_MEM;
    logic [31:0] rs2_MEM;
    logic [31:0] inst_MEM;
        //
    logic [2:0] func3_MEM;
    logic [1:0] WBsel_MEM;
    logic regW_en_MEM, Bsel_MEM, memW_en_MEM, jump_MEM, Asel_MEM, valid_branch_MEM;

    // WB signals
    logic [31:0] pc_next_WB;
    logic [31:0] ALUout_WB;
    logic [31:0] d_mem_out_WB;
    logic [31:0] instruction;
    logic [1:0] WBsel_WB;
    logic regW_en_WB;

    // for HCU
    logic [31:0] data1_EX;
    logic [31:0] data2_EX;
    // HCU control
    logic [1:0] fwd_A;
    logic [1:0] fwd_B;
    logic pc_en;
    logic IF_ID_en;
    logic ID_EX_en;
    // logic EX_MEM_en;
    logic IF_ID_flush;
    logic ID_EX_flush;
    logic EX_MEM_flush;

    // pc loading done here
    assign load_pc = jump_MEM || valid_branch_MEM; //// <<<------ jump from WB and branch from MEM

    program_counter #(.IMEM_DEPTH(IMEM_DEPTH)) PC (.clk(clk), .rst(rst), .en(pc_en),
        .load_en(load_pc), .load_val(ALUout_MEM[31:0]), // <<<----- ALUout from MEM stage
        .pc_curr(pc_curr));

  inst_mem #(.IMEM_DEPTH(IMEM_DEPTH)) IMEM (.addr(pc_curr), .data(instruction));

    // ------------------------------------ IF/ID --------------------------------- //
    IF_ID #(.IMEM_DEPTH(IMEM_DEPTH)) IF_ID (.clk(clk), .rst(rst), .en(IF_ID_en), .flush(IF_ID_flush),

        .pc_curr_IF(pc_curr),
        .inst_IF(instruction),

        .pc_curr_ID(pc_curr_ID),
        .inst_ID(inst_ID)
    );
    // ----
    
    // control signals generated here
    control CU(.instruction(inst_ID),
    .func3,
    .ALUsel,
    .WBsel,
    .regW_en, .Bsel, .memW_en, .jump, .Asel
    );
    
    reg_file RF(.clk(clk), .rst(rst),
        .dataW(regD_in), // <<<--- this is coming from WB stage
        .rs1(inst_ID[19:15]), .rs2(inst_ID[24:20]),
        .rsW(inst_WB[11:7]), .regW_en(regW_en_WB),  // <<<--------- for write back rsW (from WB stage)
        
        .data1(data1_out), .data2(data2_out),
        .debug_addr(debug_addr),.debugreg_data(debugreg_data)
        );

    imm_gen IG(.inst(inst_ID), .imm_ex(imm_ex_out));

    // ------------------------------------ ID/EX --------------------------------- //
    ID_EX #(.IMEM_DEPTH(IMEM_DEPTH)) ID_EX (.clk(clk), .rst(rst), .en(ID_EX_en), .flush(ID_EX_flush),

        // inputs
            // data signals
        .pc_curr_ID,
        .rs1_ID(data1_out),
        .rs2_ID(data2_out),
        .imm_ex_out_ID(imm_ex_out),
        .inst_ID,
            // control signals
        .func3_ID(func3),
        .ALUsel_ID(ALUsel),
        .WBsel_ID(WBsel),
        .regW_en_ID(regW_en), .Bsel_ID(Bsel), .memW_en_ID(memW_en), .jump_ID(jump), .Asel_ID(Asel),

        // outputs
            // data signals
        .pc_curr_EX,
        .rs1_EX,
        .rs2_EX,
        .imm_ex_out_EX,
        .inst_EX,
            // control signals
        .func3_EX,
        .ALUsel_EX,
        .WBsel_EX,
        .regW_en_EX, .Bsel_EX, .memW_en_EX, .jump_EX, .Asel_EX
    );
    // ----

    // forwarding mux for A --- 0: rs1_EX - 1: ALUout_MEM - 2: regD_in
    assign data1_EX = fwd_A ? (fwd_A[0] ? ALUout_MEM : regD_in) : rs1_EX;
    // forwarding mux for B --- 0: rs2_EX - 1: ALUout_MEM - 2: regD_in
    assign data2_EX = fwd_B ? (fwd_B[0] ? ALUout_MEM : regD_in) : rs2_EX;

    branch_comp BC(.A(data1_EX), .B(data2_EX), .opcode(inst_EX[6:0]), .func3(func3_EX), .valid_branch(valid_branch));

    // alu 1 mux -->> 1 - pc_curr | 0 - reg (rs1)
    assign ALUd1_in = Asel_EX ? pc_curr_EX : data1_EX; // <<----!! pc_curr_EX unmatched bits (!32)

    // alu 2 mux -->> 1 - imm gen | 0 - reg (rs2)
    assign ALUd2_in = Bsel_EX ? imm_ex_out_EX : data2_EX;

    // addi x1, x0, -4 <--- !!! done
    alu_logic ALU(.data1(ALUd1_in), .data2(ALUd2_in), .ALUsel(ALUsel_EX),
        .ALUout(ALUout));

    // ------------------------------------ EX/MEM --------------------------------- //
    EX_MEM #(.IMEM_DEPTH(IMEM_DEPTH)) EX_MEM(.clk(clk), .rst(rst), .en(1'b1), .flush(EX_MEM_flush),

        .pc_curr_EX,
        .ALUout_EX(ALUout),
        .rs2_EX(data2_EX),
        .inst_EX,
            //
        .func3_EX,
        .WBsel_EX,
        .regW_en_EX, .memW_en_EX, .jump_EX, .valid_branch_EX(valid_branch),

        .pc_curr_MEM,
        .ALUout_MEM,
        .rs2_MEM,
        .inst_MEM,
            //
        .func3_MEM,
        .WBsel_MEM,
        .regW_en_MEM, .memW_en_MEM, .jump_MEM, .valid_branch_MEM(valid_branch_MEM)
        // valid_branch_MEM is sent to pc_load from here !!
        // jump_MEM is sent to pc_load from here !!
    );

    assign pc_next_MEM = pc_curr_MEM + 4; // adder in MEM stage

    data_mem #(.DMEM_DEPTH(DMEM_DEPTH)) DMEM (.clk(clk), .memW_en(memW_en_MEM),
        .data_in(rs2_MEM), .addr(ALUout_MEM[31:0]), .func3(func3_MEM),
        .data(d_mem_out), .debug_addr(debug_addr),.debugmem_data(debugmem_data) // <--
    );

    // ------------------------------------ MEM/WB --------------------------------- //
    MEM_WB #(.IMEM_DEPTH(IMEM_DEPTH)) MEM_WB(.clk(clk), .rst(rst), .en(1'b1),
        .pc_next_MEM(pc_next_MEM),
        .ALUout_MEM,
        .d_mem_out_MEM(d_mem_out),
        .inst_MEM,

        .WBsel_MEM,
        .regW_en_MEM, .jump_MEM,

        .pc_next_WB,
        .ALUout_WB,
        .d_mem_out_WB,
        .inst_WB,

        .WBsel_WB,
        .regW_en_WB
       
    );

    // mux -->> 0 - dmem | 1 - alu | 2 - pc+4
    assign regD_in = WBsel_WB ? (WBsel_WB[0] ? ALUout_WB : pc_next_WB) : d_mem_out_WB;


    hazard_detection_unit HCU(.*);

endmodule
