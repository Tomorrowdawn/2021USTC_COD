
/*
根据riscv设计规范,浮点数写回储存在专用的Fregfile中,不传出;传出的是fsw.
*/
module FPU(
    input clk,
    input rst,
    input [31:0] inst_i,

    output [25:0] dbg_cplMAX,
    output [25:0] dbg_cplMIN,
    output [25:0] dbg_temp,
    output [4:0] dbg_FALUop,
    output [23:0]dbg_FracMAX,
    output [23:0]dbg_FracMIN,
    output dbg_hidemax,
    output dbg_hidemin,
    output dbg_PREswap,
    output [4:0] dbg_EXfRs1,
    output [4:0] dbg_PRERd,
    output [4:0] dbg_Rd,
    output dbg_swap,
    output dbg_save,
    output [47:0] dbg_fracResult,
    output [4:0] dbg_Rs1,
    output [4:0] dbg_Rs2,
    output [31:0] dbg_float,
    output fmemWrite,//fsw
    output [31:0] memfloat
);

wire save;
wire regWrite;
wire [4:0] FALUop;
wire [4:0] fRs1;
wire [4:0] fRs2;
wire [4:0] fRd;
wire [7:0] expDiff;
wire sign;
wire swap;
wire hidemax;
wire hidemin;
wire [31:0] FloatMAX;
wire [31:0] FloatMIN;
wire [31:0] Float1;
wire [31:0] Float2;
wire [4:0] norfRd;
wire norfregWrite; 
wire [31:0] float;
wire [31:0] save_Float;

SWAP SWAP_u (
.inst_i(inst_i),
.Float1(Float1),
.Float2(Float2),
.save(save),
.regWrite(regWrite),
.FALUop(FALUop),
.fRs1(fRs1),
.fRs2(fRs2),
.fRd(fRd),
.expDiff(expDiff),
.save_Float(save_Float),
.sign(sign),
.swap(swap),
.hidemax(hidemax),
.hidemin(hidemin),
.FloatMAX(FloatMAX),
.FloatMIN(FloatMIN)
);

assign dbg_save = norfRd;

assign dbg_Rs1 = inst_i[19:15];
assign dbg_Rs2 = inst_i[24:20];

Fregfile #(.SCALE(5),.WIDTH(32))registers(
    .clk(clk),
    .rst(rst),
    .ra0(inst_i[19:15]),
    .rd0(Float1),
    .ra1(inst_i[24:20]),
    .rd1(Float2),
    .wa(norfRd),
    .we(norfregWrite),
    .wd(float)
);

wire [31:0] EXsave_Float;
wire EXfregWrite;
wire [4:0] EXFALUop;
wire [4:0] EXfRs1;
wire [4:0] EXfRs2;
reg [4:0] EXfRd;
wire [7:0] EXexpDiff;
wire [7:0] EXexpMAX;
wire EXsign;
reg EXswap;
wire EXhidemax;
wire EXhidemin;
wire [31:0] EXFloatMAX;
wire [31:0] EXFloatMIN;
PRE_EX PRE_EX_u (
.clk(clk),
.rst(rst),
.PREsave(save),
.PREfregWrite(regWrite),
.PREFALUop(FALUop),
.PREfRs1(fRs1),
.PREfRs2(fRs2),
.PREfRd(fRd),
.PREexpDiff(expDiff),
.PREsign(sign),
.PREswap(swap),
.PREhidemax(hidemax),
.PREhidemin(hidemin),
.PREFloatMAX(FloatMAX),
.PREFloatMIN(FloatMIN),
.PREsave_Float(save_Float),

.EXsave(fmemWrite),
.EXsave_Float(EXsave_Float),
.EXfregWrite(EXfregWrite),
.EXFALUop(EXFALUop),
.EXfRs1(EXfRs1),
.EXfRs2(EXfRs2),
//.EXfRd(EXfRd),
.EXexpDiff(EXexpDiff),
.EXsign(EXsign),
//.EXswap(EXswap),
.EXhidemax(EXhidemax),
.EXhidemin(EXhidemin),
.EXFloatMAX(EXFloatMAX),
.EXFloatMIN(EXFloatMIN)
);


always@(posedge clk)
begin
    EXswap <= swap;
    EXfRd <= fRd;
end

//进入EX

assign memfloat = EXsave_Float;
//TODO:这个数据传到主流水的EX段!(快人一步)



wire [23:0] FracMAX;
wire [23:0] FracMIN;
Shift Shift_u (
.FloatMAX(EXFloatMAX),
.FloatMIN(EXFloatMIN),
.FALUop(EXFALUop),
.hidemax(EXhidemax),
.hidemin(EXhidemin),
.expDiff(EXexpDiff),
.FracMAX(FracMAX),
.FracMIN(FracMIN)
);


wire [7:0] expSUM;
wire [47:0] fracResult;
FALU FALU_u (
.FracMAX(FracMAX),
.FracMIN(FracMIN),
.FALUop(EXFALUop),
.swap(EXswap),

.dbg_cplMAX(dbg_cplMAX),
.dbg_cplMIN(dbg_cplMIN),
.dbg_temp(dbg_temp),
.signMAX(EXFloatMAX[31]),
.signMIN(EXFloatMIN[31]),
.expMAX(EXFloatMAX[30:23]),
.expMIN(EXFloatMIN[30:23]),
.expSUM(expSUM),
.fracResult(fracResult)
);

wire [47:0] norfracALU;
wire norswap;
wire norsign;
wire [4:0] norFALUop;
wire [7:0] norexpSUM;
wire [7:0] norexpMAX;
wire norsignMAX;

EX_NORMAL EX_NORMAL_u (
.clk(clk),
.rst(rst),
.exfracALU(fracResult),
.exswap(EXswap),
.exsign(EXsign),
.exFALUop(EXFALUop),
.exexpSUM(expSUM),
.exexpMAX(EXFloatMAX[30:23]),
.exfregWrite(EXfregWrite),
.exfRd(EXfRd),
.exsignMAX(EXFloatMAX[31]),


.norsignMAX(norsignMAX),
.norfregWrite(norfregWrite),
.norfRd(norfRd),
.norfracALU(norfracALU),
.norswap(norswap),
.norsign(norsign),
.norFALUop(norFALUop),
.norexpSUM(norexpSUM),
.norexpMAX(norexpMAX)
);


Normal Normal_u (
.fracALU(norfracALU),
.swap(norswap),
.sign(norsign),
.signMAX(norsignMAX),
.FALUop(norFALUop),
.expMAX(norexpMAX),
.expSUM(norexpSUM),
.float(float)
);



assign dbg_float = float;
assign dbg_swap = EXswap;
assign dbg_Rd = EXfRd;
assign dbg_PRERd = fRd;
assign dbg_EXfRs1 = EXfRs1;
assign dbg_PREswap = swap;
assign dbg_fracResult = fracResult;
assign dbg_hidemax = FracMAX[23];
assign dbg_hidemin = FracMIN[23];
assign dbg_FracMAX = FracMAX;
assign dbg_FracMIN = FracMIN;
assign dbg_FALUop = EXFALUop;

//TODO:主流水线修正,冲突检测与MEM输出.
endmodule