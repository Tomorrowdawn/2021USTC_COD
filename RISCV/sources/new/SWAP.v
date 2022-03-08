`include "MACRO.v"

//编码格式:
/*
f[31] = sign
f[30:23] = exp
f[22:0] = frac (origin,not complement)(we need to transfer it!)
*/

module SWAP(
    input [31:0] inst_i,//我们不做浮点分支,不送pc
    //所有冲突检测之后慢慢加

    input [31:0] Float1,
    input [31:0] Float2,//从Fregfile中读出的数据.要确保1>2,即向大对齐.

    output save,//指明是否为fsw指令,用来从FPU传出数据.它的待储存数据在SWAP外面,由Fregfile给出.
    output regWrite,//指明是否写回寄存器
    output [4:0] FALUop,//只使用一级译码.
    output [4:0] fRs1,//
    output [4:0] fRs2,//浮点寄存器源.
    output [4:0] fRd,//目标寄存器,随流水线传递
    output [7:0] expDiff,//阶码差,用于移位
    output [31:0] save_Float,//被储存数据

    output sign,//符号位.乘取异或.加减法的符号位在这一阶段无法确定,需要在计算阶段中给出
    output swap,//指示是否发生交换.如果发生,结合FALUop和计算结果确定加减运算的符号位.
    output hidemax,
    output hidemin,//隐藏位
    output [31:0] FloatMAX,
    output [31:0] FloatMIN
);

wire MUX;

assign MUX = (Float1[30:23] >= Float2[30:23]);//只有在F1<F2时才交换.这样确保只要交换,符号位就被较大者确定

assign FloatMAX = (MUX==1)?Float1:Float2;
assign FloatMIN = (MUX==1)?Float2:Float1;

assign save_Float = Float2;

assign hidemax = |FloatMAX[30:23];
assign hidemin = |FloatMIN[30:23];

assign expDiff = FloatMAX[30:23] - FloatMIN[30:23];


assign fRs1 = inst_i[19:15];
assign fRs2 = inst_i[24:20];
assign fRd = ~(~inst_i[11:7]);
assign FALUop = inst_i[31:27];

assign save = (inst_i[6:0] == `fsw);
assign regWrite = (inst_i[6:0] == `Rfsop);

assign sign = Float1[31] ^ Float2[31];
assign swap = (Float1[30:23]<Float2[30:23]);

endmodule 