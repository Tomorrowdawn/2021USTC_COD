`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 20:01:55
// Design Name: 
// Module Name: MEM
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


module MEM(
    input clk,
    input   wire[6:0]    InsType,
    input   wire         MEMWrite,
	input	wire 		 RegWrite_i,
	input   wire[4:0]	 RegDes_i,
    input   wire[31:0]   LinkAddr_i,
    input   wire[31:0]   Result_i,//Result将被当做地址使用.
    input   wire[1:0]    WBSrc_i,
    input   wire[31:0]   MEMWdata,

    output wire RegWrite_o,
    output wire [4:0] RegDes_o,
    output wire [31:0] LinkAddr_o,
    output wire [31:0] Result_o,//这里传出作为最后WB的算术结果.
    output wire [31:0] MEMdata,//储存器读出数据.
    output wire [1:0]  WBSrc_o,
    
    input [7:0] dbg_addr,
    output [31:0] dbg_data
);

assign RegWrite_o = RegWrite_i;
assign RegDes_o = RegDes_i;
assign LinkAddr_o = LinkAddr_i;
assign Result_o = Result_i;
assign WBSrc_o = WBSrc_i;

datamem DM(
    .a(Result_i[9:2]),
    .d(MEMWdata),
    .clk(clk),
    .dpra(dbg_addr),
    .we(MEMWrite & (~Result_i[10])),
    .spo(MEMdata),
    .dpo(dbg_data)
);


endmodule
