`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/14 11:43:17
// Design Name: 
// Module Name: Freg_TEST
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


module Freg_TEST();

reg rst,clk;

reg [31:0] inst;
wire [31:0] Float1,Float2;
reg [4:0] Rd;
reg regWrite;
reg [31:0] float;

initial begin
    Rd<= 0;regWrite<=0;float<=0;
end

initial begin
    inst <= 32'h00000013;
    #30 inst <= 32'h0020f253;
    #20 inst <= 32'h00000013;
    #20 inst <= 32'h00000013;
    #20 inst <= 32'h00000013;
    #20 inst <= 32'h00402027;
    #20 inst <= 32'h00000013;
    #100 $finish;
end

initial begin
    rst <= 0;
    #5 rst <= 1;
    #5 rst <=0;
end

initial
begin
    clk <= 0;
    forever #10 clk<=~clk;
end

Fregfile #(.SCALE(5),.WIDTH(32))registers(
    .clk(clk),
    .rst(rst),
    .ra0(inst[19:15]),
    .rd0(Float1),
    .ra1(inst[24:20]),
    .rd1(Float2),
    .wa(Rd),
    .we(regWrite),
    .wd(float)
);

endmodule
