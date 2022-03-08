`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 19:40:38
// Design Name: 
// Module Name: IGU
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

module IGU(
    input [31:0] Instruction,
    output reg [31:0] out
);
always@(*)
    begin
     case(Instruction[6:0])
          `jal:begin//jal
                out = {{12{Instruction[31]}}, Instruction[19:12], Instruction[20], Instruction[30:21], 1'b0};
                end
          `beq:begin//beq.这里两个跳转指令都直接做了左移
                out = {{19{Instruction[31]}},
                Instruction[31],Instruction[7],Instruction[30:25],Instruction[11:8],1'b0};
                end
          `addi:begin//addi&&lw
                out = {{20{Instruction[31]}},
                Instruction[31:20]};          
                end
            `lw:begin//addi&&lw
                out = {{20{Instruction[31]}},
                Instruction[31:20]}; 
                end
          `sw,`fsw:begin//sw
                out = {{20{Instruction[31]}},
                Instruction[31:25],Instruction[11:7]};    
                end
          default:begin
                out = 32'b0;
                end                                                                           
     endcase
    end
endmodule
