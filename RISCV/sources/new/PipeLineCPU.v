`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/02 23:33:54
// Design Name: 
// Module Name: PipeLineCPU
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

module PipeLineCPU(
    input clk,
    input rst,
    input wire [4:0]   m_rf_addr,
    output wire [31:0] m_data,
    input wire[31:0] io_din,
    output wire [31:0]    rf_data,//debug
    output wire [31:0] io_dout,
    output wire [7:0] io_addr,
    output wire io_we,
    output wire dbg_we,
    output wire [31:0] if_pc,
    output wire [31:0] IR,
    output wire [31:0] id_pc,

    output dbg_brhstall,
    output dbg_ldstall,
    output [4:0] dbg_exrdes,
    output dbg_Branch,
    output [31:0]dbg_op1,
    output [31:0]dbg_op2,
    output [31:0] dbg_inst,
    output dbg_fw1,
    output dbg_fw2,
    output dbg_equal,
    output jal,
    output  wbdata,
    output [6:0] dbg_InsType,
    output brh,
    output [31:0] dbg_Result,
    output [31:0] fwop1,
    output [4:0] dbg_RegSrc1,
    output [4:0] dbg_RegSrc2,
    output [31:0] fwop2,
    output [31:0] dbg_baddr,
    output [31:0] dbg_memdata,
    output [4:0] dbg_memrdes,
    output dbg_brstall,
    output [1:0] wbSrc,
    output [31:0] exCtrl,
    output [31:0] dbg_IMM,
    output [1:0] exALU1,
    output [1:0] exALU2,
    output [31:0] memCtrl,
    output [31:0] wbCtrl,
    //output [31:0] dbg_LinkAddr,
    output dbg_imm,

    output [31:0] dbg_wbdata,
    output [4:0] dbg_wbRegDes,
    output [31:0] dbg_ifpc
);


wire Branch;
wire [31:0] BranchAddr;
wire LoadStall;
wire BranchStall;
wire [31:0] pc;
wire [31:0] inst;
wire [31:0] idpc;
wire [31:0] idinst;

wire[4:0]   exRegDes;//用来检测冲突;指挥停顿
wire[4:0]   memRegDes;
wire[6:0]   memInsType;

wire        wbRegWrite;//WB段传回用于检测是否写入
wire[4:0]   wbRegDes;//目标寄存器.

wire[1:0]   ALUop;//传入ALUcontrol二级译码
wire[2:0]   funct3;
wire        funct7;//这三项都是ALU控制必须
wire[31:0]  IMM;
wire[31:0]  Operand1;
wire[31:0]  Operand2;//EX段所需的所有数据.
//Operand理应是从寄存器中读出的.但并不总是有效的.例如Addi并不产生Operand2.

wire[6:0]   InsType;//分支前移带来的前递

wire[31:0]  LinkAddr; //jal链接.
//这两个地址唯一的区别就是;link会被传下去写回;branch不会.

wire        MEMWrite;//用来判断是否是Save

wire        RegWrite;//用于WB段控制RegFile是否写入
wire[4:0]   RegDes;//目标寄存器地址
wire[4:0]   RegSrc1;
wire[4:0]   RegSrc2;//这里用来处理从WB前递到EX的情况.

wire        imm;
wire[1:0]   WBSrc;//WB选择器标识

wire [4:0] RegDes_o;
wire [31:0] memResult;
wire [31:0] wbResult;
wire [31:0] Result;
wire memRegWrite_o;
wire [4:0] memRegDes_o;
wire [31:0] memLinkAddr_o;
wire [31:0] memResult_o;
wire [31:0] memMEMdata;
wire [1:0] memWBSrc_o;

wire [1:0]   exWBSrc;
wire [4:0]   exRegSrc1;
wire [4:0]   exRegSrc2;
wire         exMEMWrite;
wire [1:0]   exALUop;
wire [2:0]   exfunct3;
wire         exfunct7;
wire [31:0]  exOperand1;
wire [31:0]  exOperand2;
wire [31:0]  exMEMWdata;
//wire [4:0]   exRegDes;
wire         exRegWrite;
wire [31:0]  exLinkAddr;
wire [6:0]   exInsType;
wire memRegWrite;

wire [1:0] ALUMUX1;
wire [1:0] ALUMUX2;
wire [1:0] memFW;

wire [1:0] WBSrc_o;
wire [6:0] InsType_o;
wire MEMWrite_o;
wire [31:0] LinkAddr_o;
wire [31:0] MEMWdata_o;
wire        RegWrite_o;

wire memMEMWrite;
wire [31:0] memLinkAddr;
wire [1:0] memWBSrc;
wire [31:0] memMEMWdata;

wire save_float;
wire [31:0] float;


assign dbg_brhstall = BranchStall;
assign dbg_ldstall  = LoadStall;
assign dbg_ifpc = pc;
assign dbg_Branch = Branch;
assign dbg_op1 = exOperand1;
assign dbg_op2 = exOperand2;
assign dbg_inst = inst;
assign dbg_baddr = BranchAddr;
assign io_dout = memMEMWdata;
assign io_addr = memResult[7:0];
assign io_we = memResult[10] & memMEMWrite;
assign if_pc = pc; 
assign IR = inst;
assign id_pc = idpc;
assign dbg_we = memMEMWrite;
assign dbg_IMM = IMM;

//assign dbg_LinkAddr = memLinkAddr_o;


IF IF(
    .clk(clk),
    .rst(rst),
    .Addr(BranchAddr),
    .Branch(Branch),
    .stall(LoadStall),
    .PC_out(pc)
);

insmem IM(
    .a(pc[9:2]),
    .spo(inst)
);

IF_ID FD(
    .clk(clk),
    .rst(rst),
    .LoadStall(LoadStall),
    .BranchStall(BranchStall),
    .ifPC(pc),
    .ifInst(inst),
    .idPC(idpc),
    .idInst(idinst)
);

FPU FPU(
    .clk(clk),
    .rst(rst),
    .inst_i(idinst),
    
    .fmemWrite(save_float),
    .memfloat(float)
);


wire idLoad;
wire exLoad;
wire idfloat;
wire exfloat;

ID ID(
    //草
    .clk(clk),
    .rst(rst),
    .pc_i(idpc),
    .inst_i(idinst),
    .exLoad(exLoad),

    .exRegDes(exRegDes),
    .memRegDes(memRegDes),
    .memInsType(memInsType),
    .MEMResult(memResult),

    .wbRegDes(wbRegDes),
    .wbRegData(wbResult),
    .wbRegWrite(wbRegWrite),

    .ALUop(ALUop),
    .funct3(funct3),
    .funct7(funct7),
    .IMM(IMM),
    .Operand1(Operand1),
    .Operand2(Operand2),

    .InsType(InsType),

    .LinkAddr(LinkAddr),
    .MEMWrite(MEMWrite),

    .RegWrite(RegWrite),
    .RegDes(RegDes),
    .RegSrc1(RegSrc1),
    .RegSrc2(RegSrc2),

    .exfloat(exfloat),

    .float_o(idfloat),

    .Branch(Branch),
    .BranchAddr(BranchAddr),

    .LoadStall(LoadStall),
    .Load(idLoad),
    .BranchStall(BranchStall),
    .imm(imm),
    .WBSrc(WBSrc),
    .m_rf_addr(m_rf_addr),
    .dbg_fw1(dbg_fw1),
    .dbg_fw2(dbg_fw2),
    .jal(jal),
    .brh(brh),
    .brhStall(dbg_brstall),

    .equal(dbg_equal),
    .rf_data(rf_data)
);

assign dbg_RegSrc1 = RegSrc1;
assign dbg_RegSrc2 = RegSrc2;

wire eximm;

wire imm_o;

assign dbg_imm = imm_o;

ID_EX IE(
    .clk(clk),
    .rst(rst),
    .LoadStall(LoadStall),
    .idWBSrc(WBSrc),
    .idALUop(ALUop),
    .idfunct3(funct3),
    .idfunct7(funct7),
    .idIMM(IMM),
    .imm(imm),
    .idOperand1(Operand1),
    .idOperand2(Operand2),
    .idInsType(InsType),
    .idRegSrc1(RegSrc1),
    .idRegSrc2(RegSrc2),
    .idMEMWrite(MEMWrite),
    .idRegWrite(RegWrite),
    .idRegDes(RegDes),
    .idLinkAddr(LinkAddr),
    .idLoad(idLoad),
    .idfloat(idfloat),

    .exLoad(exLoad),
    .eximm(eximm),
    .exfloat(exfloat),

    .exWBSrc(exWBSrc),
    .exRegSrc1(exRegSrc1),
    .exRegSrc2(exRegSrc2),
    .exMEMWrite(exMEMWrite),
    .exALUop(exALUop),
    .exfunct3(exfunct3),
    .exfunct7(exfunct7),
    .exOperand1(exOperand1),
    .exOperand2(exOperand2),
    .exMEMWdata(exMEMWdata),
    .exRegDes(exRegDes),
    .exRegWrite(exRegWrite),
    .exLinkAddr(exLinkAddr),
    .exInsType(exInsType)
);

assign dbg_InsType = memInsType;

assign exCtrl = {LoadStall,LoadStall,BranchStall,3'b0,ALUMUX1,2'b0,ALUMUX2,1'b0,exRegWrite,exWBSrc,2'b0,
exLoad,MEMWrite_o,10'b0,exALUop};

assign exALU1 = memFW;
assign exALU2 = ALUMUX2;

EX EX_u (
.ALUop_i(exALUop),
.Operand1_i(exOperand1),
.Operand2_i(exOperand2),
.funct7(exfunct7),
.funct3(exfunct3),
.InsType_i(exInsType),
.MEMWrite_i(exMEMWrite),
.RegDes_i(exRegDes),
.RegWrite_i(exRegWrite),
.RegDes_o(RegDes_o),
.LinkAddr_i(exLinkAddr),
.imm_i(eximm),
.imm_o(imm_o),

.ALUMUX1(ALUMUX1),
.ALUMUX2(ALUMUX2),
.memFW(memFW),
.MEMFWdata(memResult),
.WBFWdata(wbResult),
.save_float(save_float),
.float(float),

.WBSrc_i(exWBSrc),
.MEMWdata_i(exMEMWdata),
.WBSrc_o(WBSrc_o),
.InsType_o(InsType_o),
.MEMWrite_o(MEMWrite_o),
.RegWrite_o(RegWrite_o),
.LinkAddr_o(LinkAddr_o),
.Result(Result),
.dbg_fwop1(fwop1),
.dbg_fwop2(fwop2),
.MEMWdata_o(MEMWdata_o)
);



Forward Forward_u (
.Rs1(exRegSrc1),
.Rs2(exRegSrc2),
.MEMRd(memRegDes),
.imm(imm_o),
.WBRd(wbRegDes),
.memWrite(MEMWrite_o),
.MEMRegWrite(memRegWrite),
.WBRegWrite(wbRegWrite),
.ALUMUX1(ALUMUX1),
.ALUMUX2(ALUMUX2),
.memFW(memFW)
);


EX_MEM EX_MEM_u (
.clk(clk),
.rst(rst),
.exWBSrc(WBSrc_o),
.exInsType(InsType_o),
.exMEMWrite(MEMWrite_o),
.exRegWrite(RegWrite_o),
.exRegDes(RegDes_o),
.exLinkAddr(LinkAddr_o),
.exResult(Result),
.exMEMWdata(MEMWdata_o),

.memInsType(memInsType),
.memMEMWrite(memMEMWrite),
.memLinkAddr(memLinkAddr),
.memResult(memResult),
.memWBSrc(memWBSrc),
.memRegDes(memRegDes),
.memRegWrite(memRegWrite),
.memMEMWdata(memMEMWdata)
);

MEM MEM_u (
.clk(clk),
.InsType(memInsType),
.MEMWrite(memMEMWrite),
.RegDes_i(memRegDes),
.LinkAddr_i(memLinkAddr),
.RegWrite_i(memRegWrite),
.Result_i(memResult),
.WBSrc_i(memWBSrc),
.MEMWdata(memMEMWdata),
.RegWrite_o(memRegWrite_o),
.RegDes_o(memRegDes_o),
.LinkAddr_o(memLinkAddr_o),
.Result_o(memResult_o),
.MEMdata(memMEMdata),
.WBSrc_o(memWBSrc_o),
.dbg_addr({3'b0,m_rf_addr}),
.dbg_data(m_data)
);

assign memCtrl = {13'b0,memRegWrite_o,memWBSrc_o,16'b0};

MEM_WB MEM_WB_u (
.clk(clk),
.rst(rst),
.memRegWrite(memRegWrite_o),
.memRegDes(memRegDes_o),
.LinkAddr(memLinkAddr_o),
.memResult(memResult_o),
.MEMdata(memMEMdata),
.WBSrc(memWBSrc_o),
.io_din(io_din),
.wbRegWrite(wbRegWrite),
.wbRegDes(wbRegDes),
//.wbLinkAddr(dbg_LinkAddr),
.wbResult(wbResult)
);

assign wbCtrl = {13'b0,wbRegWrite,18'b0};

assign wbSrc = memWBSrc_o;
assign wbdata = wbRegWrite;
assign dbg_Result = memResult;
assign dbg_exrdes = exRegDes;
assign dbg_memdata = memMEMWdata;
assign dbg_memrdes = memRegDes;
assign dbg_wbdata = wbResult;
assign dbg_wbRegDes = wbRegDes;


endmodule
