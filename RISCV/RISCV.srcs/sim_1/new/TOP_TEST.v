`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/15 14:54:18
// Design Name: 
// Module Name: TOP_TEST
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


module TOP_TEST();


reg clk;
reg rst;
reg debug;
reg btn;

reg [4:0] m_rf_addr;
wire [31:0] rf_data;

//wire [31:0] ctrl,ctrlm,ctrlw;
wire [31:0] io_dout;
//wire [31:0] IMM;

wire [7:0] io_addr;
reg [7:0] io_data [0:31];//模拟外设
wire we;
//reg valid;

wire [3:0] seg;

initial begin
    rst <= 0;
    #20 rst <= 1;
    #20 rst <= 0;
end

initial begin
    m_rf_addr <= 0;io_data[12]<=1'b1;//16==valid,12==data_in
    #40 m_rf_addr<=5'h7;
    #1600 $stop;
end

initial begin
    debug <= 1'b1;
    btn <= 1'b0;
end


initial begin
    io_data[16]<=8'b1;
    #200 io_data[16] <= 8'b0;
    #200 io_data[16] <=8'b1;
    #200 io_data[16] <= 8'b0;
    #200 io_data[16] <= 8'b1;
end

/*
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
*/


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

wire dbg_clk;

TopPPCPU TPU(
    .clk(clk),
    .debug(debug),
    .step(btn),
    .valid(io_data[16]),
    .in(5'b0),
    .rst(rst),
    .seg(seg)
);

endmodule
