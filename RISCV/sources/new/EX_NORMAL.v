`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/13 20:09:15
// Design Name: 
// Module Name: EX_NORMAL
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


module EX_NORMAL(
    input clk,
    input rst,
    input [47:0]    exfracALU,
    input           exswap,
    input           exsign,
    input [4:0]     exFALUop,
    input [7:0]     exexpSUM,
    input [7:0]     exexpMAX,
    input exfregWrite,
    input [4:0]     exfRd,//用于写回
    input           exsignMAX,

    output reg           norsignMAX,
    output reg           norfregWrite,
    output reg [4:0]     norfRd,
    output reg [47:0]    norfracALU,
    output reg           norswap,
    output reg           norsign,
    output reg [4:0]     norFALUop,
    output reg [7:0]     norexpSUM,
    output reg [7:0]     norexpMAX
);

always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        norsignMAX <= 1'b0;
        norfracALU <= 48'b0;
        norswap <= 1'b0;
        norsign <= 1'b0;
        norFALUop <= 5'b0;
        norexpSUM <= 8'b0;
        norexpMAX <= 8'b0;
        norfRd <= 5'b0;
        norfregWrite <= 1'b0;
    end
    else 
    begin
        norsignMAX <= exsignMAX;
        norfRd <= exfRd;
        norfregWrite <= exfregWrite;
        norfracALU  <= exfracALU;
        norswap     <= exswap;
        norsign     <= exsign;
        norFALUop   <= exFALUop;
        norexpSUM   <= exexpSUM;
        norexpMAX   <= exexpMAX;
    end
end

endmodule
