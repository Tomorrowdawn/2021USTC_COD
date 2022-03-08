`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 20:01:54
// Design Name: 
// Module Name: EX
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

`include "MACRO.v"

module EX(
	input	wire[1:0]   ALUop_i,
    input   wire[31:0]  Operand1_i,
    input   wire[31:0]  Operand2_i,
    input   wire        funct7,
    input   wire[2:0]   funct3,
    input   wire[6:0]   InsType_i,

    input save_float,
    input [31:0] float,

    input imm_i,
    output imm_o,

    input   wire        MEMWrite_i,
    input   wire[4:0]   RegDes_i,
	input 	wire		RegWrite_i,
	input	wire[31:0]  LinkAddr_i,
    input   wire[1:0]   ALUMUX1,
    input   wire[1:0]   ALUMUX2,
    input   wire[1:0]   memFW,//这是前递单元传来的信号
    input   wire[31:0]  MEMFWdata,
    input   wire[31:0]  WBFWdata,//前递过来的数据
    //注意,前递单元不在EX内部.
    input wire [1:0] WBSrc_i,
    input wire [31:0]   MEMWdata_i,

    output wire [31:0] dbg_fwop1,
    output wire [31:0] dbg_fwop2,//前递检测
    output wire [1:0]   WBSrc_o,
    output  wire[6:0]   InsType_o,
    output  wire        MEMWrite_o,
	output	wire 		RegWrite_o,
	output	wire [4:0]	RegDes_o,
    output  wire[31:0]  LinkAddr_o,
    output  wire[31:0]  Result,//ALU计算结果
    //此结果充当了多个用途.包括储存器地址,运算指令结果.
    output  [31:0] MEMWdata_o
);

wire [2:0] ALUoperation;
wire zero;

reg [31:0] tempMEMWdata_o;
reg [31:0] ALUoperand1;
reg [31:0] ALUoperand2;

assign LinkAddr_o = LinkAddr_i;
assign RegWrite_o = RegWrite_i;
assign RegDes_o = RegDes_i;
assign MEMWrite_o = MEMWrite_i;
assign InsType_o = InsType_i;
assign WBSrc_o = WBSrc_i;
assign imm_o = imm_i;

always@(*)
begin
    if(ALUMUX1==`WBFW) ALUoperand1 = WBFWdata;
    else if(ALUMUX1 == `MEMFW) ALUoperand1 = MEMFWdata;
    else ALUoperand1 = Operand1_i;
end

always@(*)
begin
    if(ALUMUX2==`WBFW) ALUoperand2 = WBFWdata;
    else if(ALUMUX2 == `MEMFW) ALUoperand2 = MEMFWdata;
    else ALUoperand2 = Operand2_i;
end

always@(*)
begin
    if(memFW==`WBFW) tempMEMWdata_o <= WBFWdata;
    else if(memFW == `MEMFW) tempMEMWdata_o <= MEMFWdata;
    else tempMEMWdata_o <= MEMWdata_i;
end

assign MEMWdata_o = (save_float==0)?tempMEMWdata_o:float;

ALUcontrol ACU(
    .ALUop(ALUop_i),
    .funct7(funct7),
    .funct3(funct3),
    .Operation(ALUoperation)
);

ALU #(.WIDTH(`FULL)) ALU(
    .a(ALUoperand1),
    .b(ALUoperand2),
    .f(ALUoperation),
    .y(Result),
    .z(zero)
);

assign dbg_fwop1 = ALUoperand1;
assign dbg_fwop2 = ALUoperand2;

endmodule
