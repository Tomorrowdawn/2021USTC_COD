//this file is created to improve code readablity. 
//本文档约定:除少量较长字符为阅读方便以及操作码与汇编对齐而采用小写以外,其他均采用大写.
//主要类别永远大写,其余小写.尽量避免大小写混杂.

//ALUoperation
`define ADD 0
`define SUB 1
`define AND 2
`define OR 3
`define XOR 4
//注意,ALUop是中间译码信号,根据自己的编码表自定义,不要调用ALUoperation以防混淆


//通用指令型号指派
`define R 0
`define S 1
`define I 2
`define B 3
`define J 4
`define unknown 5

//字长(即数据长度,而非地址长度)
`define FULL 32//word
`define DOUBLE 64//double word
`define SHORT 16//short word
`define PCW 32//pc width

//状态定义
`define YES 1
`define NO 0

//操作码
`define jal 7'b1101111
`define beq 7'b1100011
`define lw 7'b0000011
`define sw 7'b0100011
`define addi 7'b0010011
`define add 7'b0110011

//F extension
`define fsw 7'b0100111
`define Rfsop 7'b1010011//这个是.S型(单精度型)R类浮点运算通用操作码.mul,div,add,sub全都一样,依赖aluop区分

`define fmulop 5'b00010
`define faddop 5'b00000
`define fsubop 5'b00001//具体的aluop

//MUX
`define MEMFW 2'b10
`define WBFW 2'b01
`define EXNORMAL 2'b00//无前递
