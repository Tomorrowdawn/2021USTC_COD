`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 20:01:54
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input   clk,
    input   rst,
    input   wire[1:0]  exWBSrc,
    input   wire[6:0]   exInsType,
    input   wire        exMEMWrite,
	input   wire 		exRegWrite,
	input	wire[4:0]	exRegDes,
    input   wire[31:0]  exLinkAddr,
    input   wire[31:0]  exResult,//ALU计算结果
    input   wire[31:0]  exMEMWdata,

    output  reg[6:0]   memInsType,
    output  reg        memMEMWrite,
	output	reg 		memRegWrite,
	output	reg [4:0]	memRegDes,
    output  reg[31:0]  memLinkAddr,
    output  reg[31:0]  memResult,
    output  reg[1:0]      memWBSrc,
    output  reg[31:0]   memMEMWdata
);

always@(posedge clk)begin
    if(rst)begin
    memInsType <= 0;
    memMEMWrite <= 0;
    memRegWrite <= 0;
    memRegDes <= 0;
    memLinkAddr <= 0;
    memResult <= 0;
    memWBSrc <= 0;
    memMEMWdata <= 0;
    end

    else begin
    memInsType <= exInsType;
    memMEMWrite <= exMEMWrite;
    memRegWrite <= exRegWrite;
    memRegDes <= exRegDes;
    memLinkAddr <= exLinkAddr;
    memResult <= exResult;
    memWBSrc <= exWBSrc;
    memMEMWdata <= exMEMWdata;
    end
end

endmodule
