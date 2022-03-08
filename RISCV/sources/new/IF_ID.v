`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 20:01:55
// Design Name: 
// Module Name: IF_ID
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

module IF_ID(
    input   wire        clk,
	input   wire        rst,
	input   wire        LoadStall,//停顿
    input   wire        BranchStall,//气泡(清零,flush)
	input   wire[31:0]	ifPC,
	input   wire[31:0]  ifInst,
	output  reg[31:0]   idPC,
	output  reg[31:0]   idInst
    );

always @ (posedge clk or posedge rst) begin
if (rst)
    idPC <= 32'h3000;
else if(LoadStall)
    idPC <= idPC;
else if (BranchStall)
    idPC <= 32'h3000;
else
    idPC <= ifPC;
end

always @ (posedge clk or posedge rst) begin
    if (rst)
        idInst <= 32'b0;
    else if (LoadStall)
        idPC <= idPC;
    else if (BranchStall)
        idInst <= 32'b0;
    else
        idInst <= ifInst;
end

endmodule
