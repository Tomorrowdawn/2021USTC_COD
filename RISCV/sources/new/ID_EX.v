`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 20:01:55
// Design Name: 
// Module Name: ID_EX
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

module ID_EX(
    input clk,
    input rst,
    input   wire        LoadStall,//只有数据冒险时才停.
    //分支指令会被传下去,因为link型指令还需要写回.

    input   wire[1:0]   idWBSrc,
    input   wire[1:0]   idALUop,//传入ALUcontrol二级译码
    input   wire[2:0]   idfunct3,
    input   wire        idfunct7,//这三项都是ALU控制必须
    input   wire[31:0]  idIMM,
    input   wire        imm,
    input   wire[31:0]  idOperand1,
    input   wire[31:0]  idOperand2,//EX段所需的所有数据.
    input   wire[6:0]   idInsType,

    input wire idLoad,
    input idfloat,
    output reg exfloat,

    input  wire [4:0]   idRegSrc1,
    input  wire [4:0]   idRegSrc2,

    input   wire        idMEMWrite,
    input   wire        idRegWrite,
    input   wire[4:0]   idRegDes,
    input   wire[31:0]  idLinkAddr,

    output  reg  [1:0]   exWBSrc,
    output  reg [4:0]   exRegSrc1,
    output  reg [4:0]   exRegSrc2,
    output  reg         exMEMWrite,
    output  reg [1:0]   exALUop,
    output  reg [2:0]   exfunct3,
    output  reg         exfunct7,
    //output  reg [31:0]  exIMM,
	output  reg [31:0]  exOperand1,
	output  reg [31:0]  exOperand2,
    output  reg [31:0]  exMEMWdata,
    output  reg [4:0]   exRegDes,
	output  reg         exRegWrite,
    output reg exLoad,
    output reg eximm,
    output  reg [31:0]  exLinkAddr,
    output  reg [6:0]   exInsType
);

always@(posedge clk)
begin
    if(rst|LoadStall)begin
        exMEMWrite <= 1'b0;
        exALUop <= 2'b0;
        exfunct3 <= 3'b0;
        exfunct7 <= 1'b0;
        //exIMM <=32'b0;
        exOperand1 <= 32'b0;
        exOperand2 <= 32'b0;
        exRegDes <= 5'b0;
        exRegWrite <= 1'b0;//nop
        exLinkAddr <= 32'b0;
        exRegSrc1 <= 5'b0;
        exRegSrc2 <= 5'b0;
        exInsType <= 7'b0;
        exWBSrc <= 0;
        exMEMWdata <= 0;
        eximm <= 0;
        exLoad <= 0;
        exfloat <= 0;
    end
    else begin
        exMEMWrite  <=  idMEMWrite;
        exALUop     <=  idALUop;
        exfunct3    <=  idfunct3;
        exfunct7    <=  idfunct7;
        //exIMM       <=  idIMM;
        exOperand1  <=  idOperand1;
        exOperand2  <=  (imm == `NO)? idOperand2:idIMM;
        exRegDes    <=  idRegDes;
        exRegWrite  <=  idRegWrite;//信号
        exLinkAddr  <=  idLinkAddr;
        exRegSrc1   <=  idRegSrc1;
        exRegSrc2   <=  idRegSrc2;
        exInsType <= idInsType;
        exWBSrc <= idWBSrc;
        exLoad <= idLoad;
        eximm <= imm;
        exfloat <= idfloat;
        exMEMWdata <= idOperand2;
    end
end

endmodule
