`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/13 09:36:57
// Design Name: 
// Module Name: Fregfile
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

//专门用于储存单精度浮点数的寄存器堆.

//编码格式:
/*
f[31] = sign
f[30:23] = exp
f[22:0] = frac 
*/

//f[0]也是可读取的.
//

module Fregfile #(parameter SCALE=5,WIDTH=32)
(
    input clk,rst,
    input [SCALE-1:0] ra0,
    output reg [WIDTH-1:0] rd0,
    input [SCALE-1:0] ra1,
    output reg [WIDTH-1:0] rd1,
    input [SCALE-1:0] ra2,
    output reg  [WIDTH-1:0] rd2,
    input [SCALE-1:0] wa,
    input we,
    input [WIDTH-1:0] wd
);
    reg [WIDTH-1:0] regfile [0:2**SCALE - 1];
    always@(*)
    begin
        if(ra0==wa)
            rd0 = wd;
        else 
            rd0 = regfile[ra0];
    end

    always@(*)
    begin
        if(ra1==wa)
            rd1 = wd;
        else 
            rd1 = regfile[ra1];
    end

    always@(*)
    begin
        if(ra2==wa)
            rd2 = wd;
        else 
            rd2 = regfile[ra2];
    end

always @(posedge clk or posedge rst)
    begin
        if(rst)begin
            regfile[0] <= 32'h3F000000;//初始化为0.5
            regfile[1] <= 32'h3E999999;//初始化为0.3
            regfile[2] <= 32'h3E8F5C28;//0.28
            regfile[3] <= 32'h3F68F5C2;//0.91
            //这三个初始值用来运行测试.因为没有设计FLW.
        end

        else if(we)
        begin
            regfile[wa] <= wd;
        end
    end
endmodule
