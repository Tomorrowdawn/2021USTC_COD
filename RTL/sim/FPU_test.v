`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/14 11:09:53
// Design Name: 
// Module Name: FPU_test
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


module FPU_test();

reg clk;
reg rst;
reg [31:0] inst;
wire [31:0] float,memfloat;
wire memWrite,save,swap,hidemax,hidemin;
//wire [4:0] Rs1,Rs2,Rd,PRERd,EXfRs1;
reg [31:0] inst_i;
wire [47:0] fracResult;
wire [4:0] FALUop;

wire [23:0] FracMAX,FracMIN;
wire [25:0] temp,cplMAX,cplMIN;

initial begin
    inst <= 32'h00000013;
    #60 inst <= 32'h1020f253;
    #20 inst <= 32'h00000013;
    #20 inst <= 32'h00000013;
    #20 inst <= 32'h00000013;
    #20 inst <= 32'h00402027;
    #20 inst <= 32'h00000013;
    #200 $finish;
end

always@(posedge clk)
begin
    inst_i <= inst;
end

initial begin
    rst <= 0;
    #5 rst <= 1;
    #10 rst <=0;
end

initial
begin
    clk <= 1;
    forever #10 clk<=~clk;
end


FPU FPU(
    .clk(clk),
    .rst(rst),
    .inst_i(inst_i),
    .dbg_float(float),
    .memfloat(memfloat),

    //.dbg_EXfRs1(EXfRs1),
    //.dbg_PREswap(PREswap),
    .dbg_hidemax(hidemax),
    .dbg_hidemin(hidemin),
    .dbg_FracMAX(FracMAX),
    .dbg_FracMIN(FracMIN),
    .dbg_FALUop(FALUop),
    .dbg_cplMAX(cplMAX),
    .dbg_cplMIN(cplMIN),

    .dbg_temp(temp),
    .dbg_fracResult(fracResult),
    //.dbg_PRERd(PRERd),
    //.dbg_Rd(Rd),
    .dbg_swap(swap),
    //.dbg_Rs1(Rs1),
    //.dbg_Rs2(Rs2),
    .dbg_save(save),
    .fmemWrite(memWrite)
);

endmodule
