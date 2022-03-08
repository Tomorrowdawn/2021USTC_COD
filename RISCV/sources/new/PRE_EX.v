`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/13 20:09:15
// Design Name: 
// Module Name: PRE_EX
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


module PRE_EX(
    input clk,
    input rst,
    input PREsave,
    input PREfregWrite,
    input [4:0]     PREFALUop,
    input [4:0]     PREfRs1,
    input [4:0]     PREfRs2,//浮点寄存器源.
    input [4:0]     PREfRd,//目标寄存器,随流水线传递
    input [7:0]     PREexpDiff,//阶码差,用于移位
    input           PREsign,//符号位.乘取异或.加减法的符号位在这一阶段无法确定,需要在计算阶段中给出
    input           PREswap,
    input           PREhidemax,
    input           PREhidemin,//隐藏位
    input [31:0]    PREFloatMAX,
    input [31:0]    PREFloatMIN,
    input [31:0]    PREsave_Float,//待储存数据

    output reg          EXsave,
    output reg [31:0]   EXsave_Float,
    output reg          EXfregWrite,
    output reg [4:0]    EXFALUop,
    output reg [4:0]    EXfRs1,
    output reg [4:0]    EXfRs2,
    output reg [4:0]    EXfRd,
    output reg [7:0]    EXexpDiff,
    output reg          EXsign,
    //output           EXswap,
    output reg          EXhidemax,
    output reg          EXhidemin,
    output reg [31:0]   EXFloatMAX,
    output reg [31:0]   EXFloatMIN
);

reg [1:0] tempswap;

always@(posedge clk or posedge rst)begin
    if(rst)
    begin
        EXsave <= 1'b0;
        EXFALUop <= 5'b0;
        EXfRs1 <= 5'b0;
        EXfRs2 <= 5'b0;
        EXfRd <= 5'b0;
        EXexpDiff <= 8'b0;
        EXsign <= 1'b0;
        EXhidemax <= 1'b0;
        EXhidemin <= 1'b0;
        EXFloatMAX <= 32'b0;
        EXFloatMIN <= 32'b0;
        EXfregWrite <= 1'b0;
        EXsave_Float <= 32'b0;
    end
    else
    begin
        EXsave <= PREsave;
        EXsave_Float <= PREsave_Float;
        EXfregWrite <= PREfregWrite;
        EXFALUop <= PREFALUop;
        EXfRs1 <= PREfRs1;
        EXfRs2 <= PREfRs2;
        EXfRd <= PREfRd;
        EXexpDiff <= PREexpDiff;
        EXsign <= PREsign;
        EXhidemax <= PREhidemax;
        EXhidemin <= PREhidemin;
        EXFloatMAX <= PREFloatMAX;
        EXFloatMIN <= PREFloatMIN;
    end
end


endmodule
