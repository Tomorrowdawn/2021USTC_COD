`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 19:40:38
// Design Name: 
// Module Name: ALU
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

module ALU #(parameter WIDTH=32)
(
    input [WIDTH-1:0] a, b,	//两操作数
    input [2:0] f,			//操作功能
    output [WIDTH-1:0] y, 	//运算结果
    output z 
);

reg [WIDTH-1:0] tempY;

always@(*)
begin
    case(f)
    3'b000:tempY=a+b;
    3'b001:tempY=a-b;
    3'b010:tempY=a&b;
    3'b011:tempY=a|b;
    3'b100:tempY=a^b;
    default:tempY=0;
    endcase
end

assign z=~|tempY;

assign y=tempY;

endmodule
