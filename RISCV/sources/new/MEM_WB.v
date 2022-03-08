`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 20:01:54
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input clk,
    input rst,
    input wire memRegWrite,
    input wire [4:0] memRegDes,
    input wire [31:0] LinkAddr,
    input wire [31:0] memResult,//这里传出作为最后WB的算术结果.
    input wire [31:0] MEMdata,//储存器读出数据.
    input wire [1:0]  WBSrc,

    input wire [31:0] io_din,//IO数据

    output reg wbRegWrite,
    output reg [4:0] wbRegDes,
    //output [31:0] wbLinkAddr,
    output reg [31:0] wbResult//这里传出作为最后WB的结果.
    //output reg [31:0] wbMEMdata,//储存器读出数据.
    //output reg [1:0]  wbWBSrc
);

reg [31:0] tmpResult;
//assign wbLinkAddr = LinkAddr;

always@(*)
begin
    if(rst) tmpResult <= 0;
    
    else if(memResult[10])
    begin
        tmpResult <= io_din;
    end
    else
    begin
        tmpResult <= MEMdata;
    end
end

always@(posedge clk)
begin
    if(WBSrc == 2'h0) wbResult <= memResult;
    else if(WBSrc == 2'h1) wbResult <= tmpResult;
    else if(WBSrc == 2'h2) wbResult <= LinkAddr;
    else wbResult <= 32'b0;
end

always@(posedge clk)
begin
    if(rst)begin
        wbRegWrite <= 0;
        wbRegDes <= 0;
    end
    else begin
    wbRegWrite <= memRegWrite;
    wbRegDes <= memRegDes;
    end
end

endmodule
