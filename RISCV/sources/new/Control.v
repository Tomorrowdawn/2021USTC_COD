`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 20:10:03
// Design Name: 
// Module Name: Control
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

module Control(
    input  [6:0] Instruction,
    output reg jal,
    output reg branch,
    //output reg Imm_gen,
    output reg [1:0] RegSrc,
    output reg [1:0] ALUop,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg imm,
    output reg Load,
    output float//指明是否为浮点操作
);

always@ (*)
    begin
    case(Instruction)
    `jal://jal
    begin
        jal = `YES;
        branch = `NO;
        //Imm_gen = `YES;
        RegSrc = 2'h2;//PC
        ALUop = 2'b00;
        MemWrite = `NO;
        ALUSrc = 1'h0;
        RegWrite = `YES;
        Load = `NO;
        imm = `YES;
    end
    `beq://beq
    begin
        jal = `NO;
        branch = `YES;
        //Imm_gen = `NO;
        RegSrc = 2'h0;//ALU
        ALUop = 2'b01;
        MemWrite = `NO;
        ALUSrc = 1'h0;
        RegWrite = `NO;
        Load = `NO;
        imm = `NO;
    end
    `lw://lw
    begin
        jal = `NO;
        branch = `NO;
        //Imm_gen = `YES;
        RegSrc = 2'h1;//MEM or IO
        ALUop = 2'b00;
        MemWrite = `NO;
        ALUSrc = 1'h1;
        RegWrite = `YES;
        Load = `YES;
        imm = `YES;
    end
    `sw,`fsw://sw
    begin
        jal = `NO;
        branch = `NO;
        //Imm_gen = `YES;
        RegSrc = 2'h0;
        ALUop = 2'b00;
        MemWrite = `YES;
        ALUSrc = 1'h1;
        RegWrite = `NO;    
        Load = `NO;
        imm = `YES;
    end
    `addi://addi
    begin
        jal = `NO;
        branch = `NO;
        //Imm_gen = `YES;
        RegSrc = 2'h0;
        ALUop = 2'b00;
        MemWrite = `NO;
        ALUSrc = 1'h1;//立即数
        RegWrite = `YES;
        Load = `NO;
        imm = `YES;     
    end
    `add://add
    begin
        jal = `NO;
        branch = `NO;
        //Imm_gen = `NO;
        RegSrc = 2'h0;
        ALUop = 2'b10;
        MemWrite = `NO;
        ALUSrc = 1'h0;//寄存器堆
        RegWrite = `YES; 
        Load = `NO;         
        imm = `NO;
    end
    default:begin
            jal = `NO;
            branch = `NO;
            RegSrc = 2'h0;
            ALUop = 2'b00;
            MemWrite = `NO;
            ALUSrc = 1'h0;
            RegWrite = `NO;
            Load = `NO;
            imm = `NO;
            end
    endcase
    end

assign float = (Instruction == `fsw || Instruction == `Rfsop);

endmodule

