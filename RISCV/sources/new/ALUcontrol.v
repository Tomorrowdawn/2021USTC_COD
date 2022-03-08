`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/02 15:35:13
// Design Name: 
// Module Name: ALUcontrol
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

module ALUcontrol(
    input [1:0] ALUop,
    input funct7,
    input [2:0] funct3,
    output reg [2:0] Operation
);

always@(*)
begin
    case(ALUop)
    2'b00:
    begin
        Operation = `ADD;//00默认加法
    end
    2'b01:
    begin
        Operation = `SUB;//01默认减法
    end
    2'b10:
    begin
        if(funct7==1) Operation = `SUB;
        else Operation = `ADD;
    end
    default:
    begin
        Operation = `ADD;
    end
    endcase
end

endmodule
