`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/03 19:23:46
// Design Name: 
// Module Name: TopPPCPU
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


module TopPPCPU(
    input debug,   //sw6
    input step,    //button
    input valid,   //sw5
    input [4:0] in,//sw4-0
    input rst,     //sw7
    input clk,     //clk100mhz
    output [1:0] check,//led6-5
    output [4:0] out0,//led4-0
    output [3:0] seg,
    output [2:0] an,   
    //an,seg   out1
    output ready    //led7
);

wire clk_cpu;
wire [7:0] io_addr;
wire [31:0] io_dout;
wire io_we;
wire [31:0] io_din;
wire [7:0] m_rf_addr;
wire [31:0] rf_data;
wire [31:0] m_data;
wire [31:0] pc;

wire [31:0] pcd,ir;
wire [31:0] a,b,ctrl,ctrlm,ctrlw;
wire [4:0] rd,rdm,rdw;
wire [31:0] y,bm,yw;

CPU_PL CPPL(
    .clk(clk_cpu),
    .rst(rst),
    .io_addr(io_addr),
    .io_dout(io_dout),
    .io_we(io_we),
    .io_din(io_din),
    .m_rf_addr(m_rf_addr),
    .rf_data(rf_data),
    .m_data(m_data),
    .pc(pc),
    .a(a),
    .pcd(pcd),
    .ir(ir),
    .b(b),
    .rd(rd),
    .rdm(rdm),
    .rdw(rdw),
    .y(y),
    .bm(bm),
    .ctrl(ctrl),
    .ctrlm(ctrlm),
    .ctrlw(ctrlw),
    .yw(yw)
);


pdu PDU (
    .clk(clk),
    .rst(rst),
    .run(debug),
    .step(step),
    .clk_cpu(clk_cpu),
    .valid(valid),
    .in(in),
    .check(check),
    .out0(out0),
    .an(an),
    .seg(seg),
    .ready(ready),
    .io_addr(io_addr),
    .io_dout(io_dout),
    .io_we(io_we),
    .io_din(io_din),
    .m_rf_addr(m_rf_addr),
    .rf_data(rf_data),
    .m_data(m_data),
    .ir(ir),
    .a(a),
    .b(b),
    .y(y),
    .bm(bm),
    .yw(yw),
    .rd(rd),
    .rdm(rdm),
    .rdw(rdw),
    .ctrl(ctrl),
    .ctrlm(ctrlm),
    .ctrlw(ctrlw),
    .pc(pc),
    .pcd(pcd)
);

endmodule
