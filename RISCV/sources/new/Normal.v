`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/13 09:37:17
// Design Name: 
// Module Name: Normal
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


//当运算是乘法时,fracALU不带符号位.
//当运算是加减法时,fracALU有符号位和溢出位.并且符号位是47,溢出位在24
module Normal(
    input [47:0] fracALU,
    input swap,
    input sign,
    input signMAX,
    input [4:0] FALUop,
    input [7:0] expMAX,//加减用
    input [7:0] expSUM,//乘除用

    output [31:0] float//一个标准IEEE单精度浮点数.不含NAN,INFINITY,一律静态舍去尾数.
);

reg signResult;
wire [7:0] expResult; 
wire [22:0] fracResult;
reg [7:0] expRevise;
reg [7:0] shift;//此值最后用来修正尾数
wire [47:0] tempfrac;

always@(*)
begin
    if(FALUop == `fmulop) signResult = sign;//乘除符号确定
    else if(FALUop == `faddop || FALUop== `fsubop) begin
         signResult = fracALU[47];//根据计算结果判定
    end
    else begin
        signResult = 0;
    end
end

//下面是移位


always@(*)begin
    if(FALUop==`fmulop) begin
        if(fracALU[47] == 1'b1) begin shift = 0; expRevise = 8'b11111111;end//阶码加一(减去-1)
        else if(fracALU[46] == 1'b1) begin shift = 8'b1;expRevise = 0;end
    end
    else if(FALUop == `faddop|| FALUop == `fsubop) begin
        if( fracALU[24:23] == 2'b10 || fracALU[24:23] == 2'b11) begin shift = 8'b11111111;expRevise = 8'b11111111; end//右移一位.阶码+1
        else if( fracALU[24:23] == 2'b00 & fracALU[22] ) begin shift =  5'd1;expRevise = 8'd1; end
        else if( fracALU[24:23] == 2'b00 & fracALU[21] ) begin shift =  5'd2;expRevise = 8'd2; end
        else if( fracALU[24:23] == 2'b00 & fracALU[20] ) begin shift =  5'd3;expRevise = 8'd3; end
        else if( fracALU[24:23] == 2'b00 & fracALU[19] ) begin shift =  5'd4;expRevise = 8'd4; end
        else if( fracALU[24:23] == 2'b00 & fracALU[18] ) begin shift =  5'd5;expRevise = 8'd5; end
        else if( fracALU[24:23] == 2'b00 & fracALU[17] ) begin shift =  5'd6;expRevise = 8'd6; end
        else if( fracALU[24:23] == 2'b00 & fracALU[16] ) begin shift =  5'd7;expRevise = 8'd7; end
        else if( fracALU[24:23] == 2'b00 & fracALU[15] ) begin shift =  5'd8;expRevise = 8'd8; end
        else if( fracALU[24:23] == 2'b00 & fracALU[14] ) begin shift =  5'd9;expRevise = 8'd9; end 
        else if( fracALU[24:23] == 2'b00 & fracALU[13] ) begin shift =  5'd10;expRevise = 8'd10; end
        else if( fracALU[24:23] == 2'b00 & fracALU[12] ) begin shift =  5'd11;expRevise = 8'd11; end
        else if( fracALU[24:23] == 2'b00 & fracALU[11] ) begin shift =  5'd12;expRevise = 8'd12; end
        else if( fracALU[24:23] == 2'b00 & fracALU[10] ) begin shift =  5'd13;expRevise = 8'd13; end
        else if( fracALU[24:23] == 2'b00 & fracALU[9] ) begin shift =  5'd14;expRevise = 8'd14; end
        else if( fracALU[24:23] == 2'b00 & fracALU[8] ) begin shift =  5'd15;expRevise = 8'd15; end
        else if( fracALU[24:23] == 2'b00 & fracALU[7] ) begin shift =  5'd16;expRevise = 8'd16; end
        else if( fracALU[24:23] == 2'b00 & fracALU[6] ) begin shift =  5'd17;expRevise = 8'd17; end
        else if( fracALU[24:23] == 2'b00 & fracALU[5] ) begin shift =  5'd18;expRevise = 8'd18; end
        else if( fracALU[24:23] == 2'b00 & fracALU[4] ) begin shift =  5'd19;expRevise = 8'd19; end
        else if( fracALU[24:23] == 2'b00 & fracALU[3] ) begin shift =  5'd20;expRevise = 8'd20; end
        else if( fracALU[24:23] == 2'b00 & fracALU[2] ) begin shift =  5'd21;expRevise = 8'd21; end
        else if( fracALU[24:23] == 2'b00 & fracALU[1] ) begin shift =  5'd22;expRevise = 8'd22; end
        else if( fracALU[24:23] == 2'b00 & fracALU[0] ) begin shift =  5'd23;expRevise = 8'd23; end
        else begin
            shift = 0;expRevise = 0;
        end
    end
    //正常情况是fracALU[24:23]=01,然后直接截取fracALU[22:0]
end

assign tempfrac = (shift==8'b11111111)?(fracALU >> 1):(fracALU << shift);
assign expResult = (FALUop == `fmulop)?(expSUM - expRevise):(expMAX - expRevise);

assign fracResult = (FALUop == `fmulop)?tempfrac[46:24]:tempfrac[22:0];//乘除取高,加减取低
//这里从46开始取,保证隐藏位.

assign float = {signResult,expResult,fracResult};//完成运算

endmodule
