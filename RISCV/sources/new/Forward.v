`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/02 14:51:23
// Design Name: 
// Module Name: Forward
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

module Forward(
    input wire [4:0] Rs1,
    input wire [4:0] Rs2,
    input wire [4:0] MEMRd,
    input wire [4:0] WBRd,
    input wire       imm,
    input wire       memWrite,//如果写入内存,前递储存数
    input wire       MEMRegWrite,
    input wire       WBRegWrite,//这两个信号是为了防止误判.有可能某条指令的[7:4]很小,比如为1,但并不是Rd段,这就会造成误判.

    output reg [1:0] memFW,
    output reg [1:0] ALUMUX1,
    output reg [1:0] ALUMUX2
);

always@(*)
begin
    if(MEMRegWrite & (MEMRd!=0) & (Rs1==MEMRd))
    begin
        ALUMUX1 = `MEMFW;
    end
    else if(WBRegWrite & (WBRd!=0) & (Rs1 == WBRd))begin
        ALUMUX1 = `WBFW;
    end
    else//default
    begin
        ALUMUX1 = `EXNORMAL;
    end
end
//Rd==0就意味着丢弃了这个值,不能前递.另外MEM的优先级高于WB.

//注意,ALUMUX2需要区分imm与operand2.

always@(*)
begin
    if(MEMRegWrite & (MEMRd!=0) & (Rs2==MEMRd) & ~imm)
    begin
        ALUMUX2 = `MEMFW;
    end
    else if(WBRegWrite & (WBRd!=0) & (Rs2 == WBRd) & ~imm)begin
        ALUMUX2 = `WBFW;
    end
    else//default
    begin
        ALUMUX2 = `EXNORMAL;
    end
end

always@(*)
begin
    if(MEMRegWrite & (MEMRd!=0) & (Rs2==MEMRd) & memWrite)
    begin
        memFW = `MEMFW;
    end
    else if(WBRegWrite & (WBRd!=0) & (Rs2 == WBRd) & memWrite)begin
        memFW = `WBFW;
    end
    else//default
    begin
        memFW = `EXNORMAL;
    end
end


endmodule
