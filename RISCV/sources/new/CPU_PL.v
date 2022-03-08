`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/03 17:56:58
// Design Name: 
// Module Name: CPU_PL
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


module CPU_PL(
  input clk, 
  input rst,

  //IO_BUS
  output [7:0] io_addr,      //led和seg的地址
  output [31:0] io_dout,     //输出led和seg的数据
  output io_we,                 //输出led和seg数据时的使能信号
  input [31:0] io_din,        //来自sw的输入数据

  //Debug_BUS
  input [7:0] m_rf_addr,   //存储器(MEM)或寄存器堆(RF)的调试读口地址
  output [31:0] rf_data,    //从RF读取的数据
  output [31:0] m_data,    //从MEM读取的数据

  //PC/IF/ID 流水段寄存器
  output [31:0] pc,
  output [31:0] pcd,
  output [31:0] ir,
  //output [31:0] pcin,

  //ID/EX 流水段寄存器
  //output [31:0] pce,
  output [31:0] a,
  output [31:0] b,
  //output [31:0] imm,
  output [4:0] rd,
  output [31:0] ctrl,

  //EX/MEM 流水段寄存器
  output [31:0] y,
  output [31:0] bm,
  output [4:0] rdm,
  output [31:0] ctrlm,

  //MEM/WB 流水段寄存器
  output [31:0] yw,
  //output [31:0] mdr,
  output [4:0] rdw,
  output [31:0] ctrlw
);


wire [31:0] if_pc;
wire [31:0] IR;
wire dbg_brhstall;
wire dbg_ldstall;
wire [4:0] dbg_exrdes;
wire dbg_Branch;
wire [31:0] dbg_op1;
wire [31:0] dbg_op2;
wire [31:0] dbg_inst;
wire dbg_fw1;
wire dbg_fw2;
wire dbg_equal;
wire jal;
wire wbdata;
wire [6:0] dbg_InsType;
wire brh;
wire [31:0] dbg_Result;
wire [31:0] fwop1;
wire [4:0] dbg_RegSrc1;
wire [4:0] dbg_RegSrc2;
wire [31:0] fwop2;
wire [31:0] dbg_baddr;
wire [31:0] dbg_ifpc;
PipeLineCPU PipeLineCPU_u (
.clk(clk),
.rst(rst),
.m_rf_addr(m_rf_addr[4:0]),
.m_data(m_data),
.io_din(io_din),
.rf_data(rf_data),
.io_dout(io_dout),
.io_addr(io_addr),
.io_we(io_we),
.if_pc(pc),
.id_pc(pcd),
.IR(ir),
.dbg_brhstall(dbg_brhstall),
.dbg_ldstall(dbg_ldstall),
.dbg_exrdes(rd),
.dbg_Branch(dbg_Branch),
.dbg_op1(a),
.dbg_op2(b),
.dbg_inst(dbg_inst),
.dbg_fw1(dbg_fw1),
.dbg_fw2(dbg_fw2),
.dbg_equal(dbg_equal),
.jal(jal),
.wbdata(wbdata),
.dbg_InsType(dbg_InsType),
.brh(brh),
.dbg_Result(y),
.dbg_memdata(bm),
.dbg_memrdes(rdm),

.fwop1(fwop1),
.dbg_RegSrc1(dbg_RegSrc1),
.dbg_RegSrc2(dbg_RegSrc2),

.dbg_wbdata(yw),
.dbg_wbRegDes(rdw),
.fwop2(fwop2),
.dbg_baddr(dbg_baddr),
.exCtrl(ctrl),
.memCtrl(ctrlm),
.wbCtrl(ctrlw),
.dbg_ifpc(dbg_ifpc)
);



endmodule
