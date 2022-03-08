`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 20:01:55
// Design Name: 
// Module Name: ID
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

//ID主要是进行解码以及寄存器读取操作.
/*
解码数据:立即数(跳转,或成为ALU操作数)
Reg地址:被用于ALU.Reg内部数据将可能有多种用途.
ALUop:指导ALU操作.
以上数据均在EX使用完毕,不再传递.EX段将通过这些数据生成后续段MEM,WB所需数据.
*/

module ID(
    input   wire        clk,
    input   wire        rst,
    input   wire[31:0]  pc_i,
    input   wire[31:0]  inst_i,  

    input   wire[4:0]   exRegDes,//用来检测冲突,指挥停顿
    input   wire[4:0]   memRegDes,
    input   wire[6:0]   memInsType,
    input   wire[31:0]  MEMResult,

    input   wire        wbRegWrite,//WB段传回用于检测是否写入
    input   wire[4:0]   wbRegDes,//目标寄存器.
    input   wire[`FULL-1:0] wbRegData,//ALU计算出的结果

    input wire exLoad,

    input exfloat,

    output  wire[1:0]   ALUop,//传入ALUcontrol二级译码
    output  wire[2:0]   funct3,
    output  wire        funct7,//这三项都是ALU控制必须
    output  wire[31:0]  IMM,
    output  wire[31:0]  Operand1,
    output  wire[31:0]  Operand2,//EX段所需的所有数据.
    //Operand理应是从寄存器中读出的.但并不总是有效的.例如Addi并不产生Operand2.

    output  wire[6:0]   InsType,//分支前移带来的前递
    
    output  wire        Branch,       //指挥是否跳转
    output  wire[31:0]  BranchAddr,   // 跳转地址
    output  wire[31:0]  LinkAddr, //jal链接.
    //这两个地址唯一的区别就是,link会被传下去写回,branch不会.

    output  wire        MEMWrite,//用来判断是否是Save

    output  wire        RegWrite,//用于WB段控制RegFile是否写入
    output  wire[4:0]   RegDes,//目标寄存器地址
    output  wire[4:0]   RegSrc1,
    output  wire[4:0]   RegSrc2,//这里用来处理从WB前递到EX的情况.

    output  wire        LoadStall,//指挥停顿.
    output  wire        BranchStall,//flush
    output  wire        imm,
    output  wire[1:0]   WBSrc,//WB选择器标识
    output wire Load,
    output wire float_o,

    input [4:0]   m_rf_addr,
    output dbg_fw1,
    output dbg_fw2,
    output equal,
    output jal,
    output brh,
    output brhStall,
    output [`FULL-1:0]    rf_data//debug
);

parameter SCALE = 5;

wire HazardStall;
//wire brhStall;
//wire equal;
//wire jal;
//wire brh;//brh仅仅指示是否是branch类型指令,而并不说明是否真的跳转.需要辅助equal
wire [31:0] cmp1;
wire [31:0] cmp2;
wire [31:0] brhFW1;
wire [31:0] brhFW2;
wire fw1,fw2;//brh前递标识.
wire [31:0] op1;
wire [31:0] op2;//operand
wire idfloat;



assign cmp1 = (fw1==1'b1)?brhFW1:op1;
assign cmp2 = (fw2==1'b1)?brhFW2:op2;//前递
assign dbg_fw1 = fw1;
assign dbg_fw2 = fw2;

assign equal = (cmp1 == cmp2);
assign Branch = jal | (brh & equal);
assign LoadStall = HazardStall | brhStall;

assign Operand1 = op1;
assign Operand2 = op2;

assign funct7 = inst_i[30];
assign funct3 = inst_i[14:12];

assign RegDes = inst_i[11:7];

assign InsType = inst_i[6:0];

Control CU(
    .Instruction(inst_i[6:0]),
    .jal(jal),
    .branch(brh),
    .ALUop(ALUop),
    .RegWrite(RegWrite),
    .Load(Load),
    .MemWrite(MEMWrite),
    .float(idfloat),
    .imm(imm),
    .RegSrc(WBSrc)
);

assign RegSrc1 = inst_i[19:15];
assign RegSrc2 = inst_i[24:20];
assign float_o = idfloat;

HDU #(.SCALE(SCALE)) Hazard(
    .exLoad(exLoad),
    .exRegDes(exRegDes),
    .RegSrc1(inst_i[19:15]),
    .RegSrc2(inst_i[24:20]),

    .idfloat(idfloat),
    .exfloat(exfloat),

    .Branch(Branch),
    .LoadStall(HazardStall),
    .BranchStall(BranchStall)
);

BrhUnit BRU(
    .branch(brh),
    .Rs1(RegSrc1),
    .Rs2(RegSrc2),
    .id_ex_Rd(exRegDes),
    .ex_mem_Rd(memRegDes),
    .ex_mem_InsType(memInsType),
    .MEMResult(MEMResult),

    .LoadStall(brhStall),
    .FWdata1(brhFW1),
    .FWdata2(brhFW2),
    .fw1(fw1),
    .fw2(fw2)
);

Regfile #(.SCALE(SCALE),.WIDTH(`FULL)) Register(
    .clk(clk),

    .wa(wbRegDes),
    .we(wbRegWrite),
    .wd(wbRegData),

    .ra0(inst_i[19:15]),
    .rd0(op1),
    
    .ra1(inst_i[24:20]),
    .rd1(op2),
    
    .ra2(m_rf_addr),
    .rd2(rf_data)
);

IGU ImmUnit(
    .Instruction(inst_i),
    .out(IMM)
);

assign BranchAddr = pc_i + IMM;

assign LinkAddr = BranchAddr;//TODO:上板的时候好像存错了

endmodule
