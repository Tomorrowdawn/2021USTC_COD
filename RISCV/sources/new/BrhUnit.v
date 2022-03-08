`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/02 16:55:39
// Design Name: 
// Module Name: BrhUnit
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

//此模块要完成以下任务:解决branch的冲突问题.它工作于ID,所以可以直接拿到指令
//为此,我们需要传入brh标识以确认当前是beq类指令在运行
//同时,我们需要ID/EX的目标寄存器和EX/MEM的目标寄存器.
//显然,ID/EX的寄存器优先级最高.
//同时,我们需要获取指令信息,用来查找流水线中值什么时候有效,并控制停顿时间.

//特别,这里需要对指令定制化处理.显然Addi与Sw是不一样的.
//add,addi:停顿一次,在EX/MEM寄存器上前递.前递最好在寄存器上进行,以防冒险
//lw:停顿两次.lw的值必须在MEM/WB处前递.

/*
当然,实际设计中是这样的:
ID/EX:发现add/addi:停顿一次
发现lw:停顿一次(然后lw进入到EX/MEM)
EX/MEM:发现add/addi:前递
发现lw:停顿一次(然后lw进入MEM/WB)
由于我们的regfile是写优先,所以WB那里不需要前递,也就不需要检查.
*/

`include "MACRO.v"

module BrhUnit(
    input wire branch,//仅仅检测b类型.j没有这个问题.
    input wire [4:0] Rs1,
    input wire [4:0] Rs2,
    input wire [4:0] id_ex_Rd,
    input wire [4:0] ex_mem_Rd,

    input wire [6:0] ex_mem_InsType,
    input wire [31:0] MEMResult,

    output wire LoadStall,
    output reg fw1,
    output reg fw2,//check=1,使用fwdata;否则使用寄存器值.
    output reg [31:0] FWdata1,
    output reg [31:0] FWdata2
);

reg LS1,LS2;

assign LoadStall = LS1 | LS2;


always@(*)
begin
    if(branch)begin
        if((id_ex_Rd!=0)&(id_ex_Rd == Rs1))begin
            LS1 = `YES;//无论什么,都停一次.
            fw1 = `NO;
            FWdata1 = 32'b0;//传个空.
        end
        else if((ex_mem_Rd!=0)&(ex_mem_Rd == Rs1))begin
            if(ex_mem_InsType == `add||ex_mem_InsType == `addi)begin
                LS1 = `NO;
                fw1 = `YES;
                FWdata1 = MEMResult;
            end
            else if(ex_mem_InsType == `lw)begin
                LS1 = `YES;
                fw1 = `NO; 
                FWdata1 = 32'b0;
            end
            else begin
                LS1 = `NO;
                fw1 = `NO;
                FWdata1 = 32'b0;
            end
        end
        else begin
            LS1 = `NO;
            fw1 = `NO;
            FWdata1 = 32'b0;
        end
    end
    else begin
        LS1 = `NO;
        fw1 = `NO;
        FWdata1 = 32'b0;
    end
end

always@(*)
begin
    if(branch)begin
        if((id_ex_Rd!=0)&(id_ex_Rd == Rs2))begin
            LS2 = `YES;//无论什么,都停一次.
            fw2 = `NO;
            FWdata2 = 32'b0;//传个空.
        end
        else if((ex_mem_Rd!=0)&(ex_mem_Rd == Rs2))begin
            if(ex_mem_InsType == `add||ex_mem_InsType == `addi)begin
                LS2 = `NO;
                fw2 = `YES;
                FWdata2 = MEMResult;
            end
            else if(ex_mem_InsType == `lw)begin
                LS2 = `YES;
                fw2 = `NO; 
                FWdata2 = 32'b0;
            end
            else begin
                LS2 = `NO;
                fw2 = `NO;
                FWdata2 = 32'b0;
            end
        end
        else begin
            LS2 = `NO;
            fw2 = `NO;
            FWdata2 = 32'b0;
        end
    end
    else begin
        LS2 = `NO;
        fw2 = `NO;
        FWdata2 = 32'b0;
    end
end


endmodule
