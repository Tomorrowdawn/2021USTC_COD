`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 20:01:55
// Design Name: 
// Module Name: IF
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

module IF(
    input	wire 		clk,
	input	wire		rst,
    //input   wire        flush,
	input 	wire		Branch,
	input 	wire[31:0] 	Addr,
	input	wire 	    stall,
	output	reg [31:0] 	PC_out//这个输出接在insmem上获取指令.
);

    always @ (posedge clk or posedge rst) begin
	if (rst)
		PC_out <= 32'h3000;
	else if (stall) begin
			PC_out <= PC_out;  
        end
	else if(Branch) PC_out <= Addr;
	else begin
		PC_out <= PC_out + 4'h4;
	end
    end
endmodule
