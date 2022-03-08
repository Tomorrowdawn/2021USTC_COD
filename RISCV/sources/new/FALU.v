`include "MACRO.v"

//编码格式:
/*
f[31] = sign
f[30:23] = exp
f[22:0] = frac 
*/

//这里的Frac都是已经移位,补齐隐藏位之后的.
module FALU(
    input [23:0] FracMAX,
    input [23:0] FracMIN,//ALU不计算指数和符号位.指数必须等到标准化结束之后才能知道,符号位也必须等待ALU的结果.
    input [4:0] FALUop,
    input signMAX,
    input signMIN,//这两个信号用来求补.
    input swap,//用来指示是否发生过交换,判定减法
    input [7:0] expMAX,
    input [7:0] expMIN,

    output [25:0] dbg_cplMAX,
    output [25:0] dbg_cplMIN,
    output [25:0] dbg_temp,
    output [7:0] expSUM,
    output reg [47:0] fracResult
);

reg [25:0] temp;//额外添上了一位用来检测溢出
reg [47:0] tempMUL;
wire [25:0] cplMAX,cplMIN;//complement

assign cplMAX = (signMAX==0)?{2'b0,FracMAX}:({1'b1,~{1'b0,FracMAX}+24'b1});
assign cplMIN = (signMIN==0)?{2'b0,FracMIN}:({1'b1,~{1'b0,FracMIN}+24'b1});
//这里额外多出的一个1'b0就是溢出位

assign dbg_temp = temp;
assign dbg_cplMAX = cplMAX;
assign dbg_cplMIN = cplMIN;

always@(*)
begin
    case(FALUop)
    `faddop:begin temp = cplMAX + cplMIN; tempMUL = 48'b0; end
    `fsubop:begin temp = (swap == 1'b0)?(cplMAX + (~cplMIN + 26'b1)):(cplMIN + (~cplMAX+26'b1)); tempMUL = 48'b0; end
    `fmulop:begin tempMUL = FracMAX * FracMIN; temp = 26'b0; end
    default:begin
        temp = 26'b0;
        tempMUL = 48'b0;
    end
    endcase
end

always@(*)
begin
    case(FALUop)
    `faddop,`fsubop:begin
        fracResult = (temp[25]==0)?{22'b0,temp}:{1'b1,22'b0,~temp[24:0]+1'b1};
    end
    `fmulop:begin fracResult = tempMUL;end
    default:begin
        fracResult = 48'b0;
    end
    endcase
end
//保证送出来的一定是原码

//下面是处理阶码的部分,与尾数并行

wire [7:0] realexpMIN;

assign realexpMIN = expMIN - 8'd127;//0111 1111

assign expSUM = realexpMIN + expMAX;//这里大费周章使用中间变量是为了防止意外加法溢出.毕竟0111 1111还是很大的

endmodule