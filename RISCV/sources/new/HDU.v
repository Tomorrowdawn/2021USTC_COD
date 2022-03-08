`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 21:52:02
// Design Name: 
// Module Name: HDU
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

//Hazard Detection Unit
`include "MACRO.v"

module HDU #(parameter SCALE=5)(
    input             exLoad,//注:R型或I型的寄存器冲突由前递来解决,而不是停顿.
    input [SCALE-1:0] exRegDes,
    input [SCALE-1:0] RegSrc1,//若上一条指令是lw,且目标寄存器与下一条指令的源寄存器重叠,那么停顿一次
    input [SCALE-1:0] RegSrc2,
    input             Branch,
    input             idfloat,
    input             exfloat,//遇到浮点指令冲突就停.

    output LoadStall,
    output BranchStall//只要分支,就发出这条指令,用来清空流水线
);//特别,如果jal与下一条指令数据冒险,也由前递解决.

assign BranchStall = Branch;
assign LoadStall = ((exLoad | (idfloat & exfloat)) & 
((exRegDes == RegSrc1)||(exRegDes == RegSrc2)) & (exRegDes != 0));

//注意,整型指令与浮点指令并不冲突.

//浮点流水与整型流水:

/*
ID - EX - MEM - WB
PRE - EX - NORMAL 规格化结尾立刻写回写优先浮点寄存器,无须停顿.

其中FEX -> EX有一条数据传递线.
*/

endmodule
