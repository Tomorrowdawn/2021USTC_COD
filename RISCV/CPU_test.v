`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/03 12:15:20
// Design Name: 
// Module Name: CPU_test
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


module CPU_test();

reg clk;
reg rst;

reg [4:0] m_rf_addr;
wire [31:0] rf_data;

//wire [31:0] ctrl,ctrlm,ctrlw;
wire [31:0] io_dout;
//wire [31:0] IMM;

wire [7:0] io_addr;
reg [7:0] io_data [0:31];//模拟外设
//wire we;
//reg valid;

initial begin
    rst <= 1'b1;m_rf_addr <= 0;io_data[12]<=1'b1;//16==valid,12==data_in
    #40 rst <= 1'b0;m_rf_addr<=5'h7;
    #1600 $stop;
end


initial begin
    io_data[16]<=8'b1;
    #200 io_data[16] <= 8'b0;
    #200 io_data[16] <=8'b1;
    #200 io_data[16] <= 8'b0;
    #200 io_data[16] <= 8'b1;
end


    wire [31:0] pc;
    wire ldstall,brhstall;
    wire [4:0] dbg_exrdes,Rs1,Rs2;
    wire dbg_Branch,fw1,fw2,equal,jal;
    wire [31:0] dbg_op1,dbg_op2,dbg_inst,Result,baddr;
    wire wd,brh;
    wire [6:0] InsType;
    wire [31:0] fwop1,fwop2,LinkAddr;
    wire brstall;
    wire [31:0] id_pc;
    wire [1:0] wbsrc,exALU1,exALU2;
    wire io_we,imm;



/*
initial begin
    io_data[16]<=8'b1;
    #140 io_data[16] <= 8'b0;
    #100 io_data[16] <= 8'b1;
    #100 io_data [16] <= 8'b0;
    #120 io_data [16] <= 8'b1;
end*/

initial
begin
    clk <= 0;
    forever #10 clk<=~clk;
end

PipeLineCPU PLCPU(
    .clk(clk),
    .rst(rst),

    .m_rf_addr(m_rf_addr),
    .rf_data(rf_data),
    .io_addr(io_addr),
    .io_din({24'b0,io_data[io_addr[4:0]]}),
    .io_dout(io_dout),

    .dbg_we(we),
    .io_we(io_we),
    .dbg_IMM(IMM),

    .dbg_op1(dbg_op1),
    .dbg_op2(dbg_op2),

    .dbg_ldstall(ldstall),
    .dbg_brhstall(brhstall),
    .dbg_exrdes(dbg_exrdes),
    .dbg_Branch(dbg_Branch),
    .dbg_inst(dbg_inst),
    .dbg_fw1(fw1),
    .dbg_fw2(fw2),
    .dbg_equal(equal),
    .jal(jal),
    .wbdata(wd),
    .dbg_InsType(InsType),
    .brh(brh),
    .dbg_Result(Result),
    .fwop1(fwop1),
    .fwop2(fwop2),
    .dbg_RegSrc1(Rs1),
    .dbg_RegSrc2(Rs2),
    .dbg_baddr(baddr),
    .dbg_brstall(brstall),
    .id_pc(id_pc),
    .exALU1(exALU1),
    .exALU2(exALU2),
    //.dbg_LinkAddr(LinkAddr),
    //.dbg_wbdata(Result),
    .wbSrc(wbsrc),
    .dbg_ifpc(pc),
    .dbg_imm(imm)
);

endmodule
