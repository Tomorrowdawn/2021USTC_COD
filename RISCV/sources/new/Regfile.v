`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 19:40:38
// Design Name: 
// Module Name: Regfile
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


module Regfile #(parameter SCALE=3,WIDTH=32)
(
    input clk,
    input [SCALE-1:0] ra0,
    output reg [WIDTH-1:0] rd0,
    input [SCALE-1:0] ra1,
    output reg [WIDTH-1:0] rd1,
    input [SCALE-1:0] ra2,
    output reg  [WIDTH-1:0] rd2,
    input [SCALE-1:0] wa,
    input we,
    input [WIDTH-1:0] wd
);
    reg [WIDTH-1:0] regfile [0:2**SCALE - 1];
    /*integer i;
    initial begin
        for(i = 0; i < 2**SCALE;i = i+1)begin
            regfile[i] <= 0;
        end
    end*/
    always@(*)
    begin
        if(!ra0) rd0 = 0;
        else
        begin
            if(ra0==wa)
            rd0 = wd;
            else 
            rd0 = regfile[ra0];
        end
    end

    always@(*)
    begin
        if(!ra1) rd1 = 0;
        else
        begin
            if(ra1==wa)
            rd1 = wd;
            else 
            rd1 = regfile[ra1];
        end
    end

    always@(*)
    begin
        if(!ra2) rd2 = 0;
        else
        begin
            if(ra2==wa)
            rd2 = wd;
            else 
            rd2 = regfile[ra2];
        end
    end

always @(posedge clk)
    begin
        if(we)
        begin
            regfile[wa] <= wd;
        end
    end
endmodule