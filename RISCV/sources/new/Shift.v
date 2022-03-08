`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/13 19:49:28
// Design Name: 
// Module Name: Shift
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

//本模块根据expDiff和exp进行移位和隐藏位恢复处理.
`include "MACRO.v"
module Shift(
    input [31:0] FloatMAX,
    input [31:0] FloatMIN,
    input hidemax,
    input hidemin,
    input [7:0] expDiff,
    input [4:0] FALUop,

    output [23:0] FracMAX,
    output [23:0] FracMIN
);

wire [23:0] tempFrac;

assign tempFrac = {hidemin,FloatMIN[22:0]};

assign FracMAX = {hidemax,FloatMAX[22:0]};

assign FracMIN = (FALUop==`fmulop)?tempFrac:(tempFrac >> expDiff);

endmodule
