module  pdu(
  input clk,
  input rst,

  //选择CPU工作方式;
  input run, 
  input step,
  output clk_cpu,

  //输入switch的端口
  input valid,
  input [4:0] in,

  //输出led和seg的端口 
  output [1:0] check,  //led6-5:查看类型
  output [4:0] out0,   //led4-0
  output [2:0] an,     //8个数码管
  output [3:0] seg,
  output ready,        //led7

  //IO_BUS
  input [7:0] io_addr,
  input [31:0] io_dout,
  input io_we,
  output [31:0] io_din,

  //Debug_BUS
  output reg[7:0] m_rf_addr,
  input [31:0] rf_data,
  input [31:0] m_data,

  //增加流水线寄存器调试接口
  input [31:0] pc, pcd,
  input [31:0] ir,
  input [31:0] a, b, y, bm, yw,
  input [4:0]  rd, rdm, rdw,
  input [31:0] ctrl, ctrlm, ctrlw 
);

reg [4:0] in_r, in_2r;    //同步外部输入用，为信号in增加一级寄存器
reg run_r, step_r, step_2r, valid_r, valid_2r;
wire step_p, valid_pn;    //取边沿信号
wire pre_pn,next_pn;      //增加取边沿信号

reg clk_cpu_r;      //寄存器输出CPU时钟
reg [4:0] out0_r;   //输出外设端口
reg [31:0] out1_r;
reg ready_r;
reg [19:0] cnt;     //刷新计数器，刷新频率约为95Hz
reg [1:0] check_r;  //查看信息类型, 00-运行结果，01-寄存器堆，10-存储器，11-plr


reg [7:0] io_din_a; //_a表示为满足组合always描述要求定义的，下同
reg [4:0] out0_a;
reg [31:0] out1_a;
reg [3:0] seg_a;

//增加pre,next取边沿计数器
reg [4:0] cnt_m_rf;     //寄存器堆和存储器地址计数器
reg [1:0] cnt_ah_plr;   //流水线寄存器高两位地址计数器
reg [2:0] cnt_al_plr;   //流水线寄存器低三位地址计数器

//增加流水线寄存器地址和数据选择输入
wire [4:0] addr_plr ;  
reg [31:0] plr_data;   

assign clk_cpu = clk_cpu_r;
assign io_din = io_din_a;
assign check = check_r;
assign out0 = out0_a;
assign ready = ready_r;
assign seg = seg_a;
assign an = cnt[19:17];
assign step_p = step_r & ~step_2r;     //取上升沿
assign valid_pn = valid_r ^ valid_2r;  //取上升沿或下降沿
assign pre_pn =in_r[1] ^in_2r[1];      //增加pre取上升或下降沿信号
assign next_pn =in_r[0] ^in_2r[0];     //增加next取上升或下降沿信号

//同步输入信号
always @(posedge clk) begin
  run_r <= run;
  step_r <= step;
  step_2r <= step_r;
  valid_r <= valid;
  valid_2r <= valid_r;
  in_r <= in;   
  in_2r <= in_r;        //为信号in增加一级寄存器
end

//CPU工作方式
always @(posedge clk, posedge rst) begin
  if(rst)
    clk_cpu_r <= 0;
  else if (run_r)
    clk_cpu_r <= ~clk_cpu_r;
  else
    clk_cpu_r <= step_p;
end

//读外设端口
always @* begin
  case (io_addr)
    8'h0c: io_din_a = {{27{1'b0}}, in_r};
    8'h10: io_din_a = {{31{1'b0}}, valid_r};
    default: io_din_a = 32'h0000_0000;
  endcase
end

//写外设端口
always @(posedge clk, posedge rst) begin
if (rst) begin
  out0_r <= 5'h1f;
  out1_r <= 32'h1234_5678;
  ready_r <= 1'b1;
end
else if (io_we)
  case (io_addr)
    8'h00: out0_r <= io_dout[4:0];
    8'h04: ready_r <= io_dout[0];
    8'h08: out1_r <= io_dout;
    default: ;
  endcase
end

//增加寄存器堆和存储器地址计数：依靠pre,next边沿计数使能
always @(posedge clk, posedge rst) begin
  if (rst) cnt_m_rf <= 5'b0_0000;
  else if (step_p)
	cnt_m_rf <= 5'b0_0000;
  else if (next_pn)
	cnt_m_rf <= cnt_m_rf + 5'b0_0001;
  else if (pre_pn)
	cnt_m_rf <= cnt_m_rf - 5'b0_0001;
end

//增加流水寄存器地址计数，流水线寄存器高两位地址依靠pre边沿计数，低三位地址依靠next边沿计数
always @(posedge clk, posedge rst) begin
  if (rst) cnt_ah_plr <= 2'b00;
  else if (step_p)
    cnt_ah_plr <= 2'b00;
  else if (pre_pn)
	cnt_ah_plr <= cnt_ah_plr + 2'b01;
end

always @(posedge clk, posedge rst) begin
  if (rst) cnt_al_plr <= 3'b000;
  else if (step_p)
	cnt_al_plr <= 3'b000;
  else if (next_pn)
	if (cnt_ah_plr==2'b01)
		if (cnt_al_plr == 3'b101)
			cnt_al_plr <= 3'b000;
		else cnt_al_plr <= cnt_al_plr + 3'b001;
	else begin
		cnt_al_plr [2] <= 1'b0;
		cnt_al_plr [1:0] <= cnt_al_plr[1:0] + 2'b01; 
	end
end

assign  addr_plr = {cnt_ah_plr,cnt_al_plr};  //增加流水线寄存器地址

//寄存器堆和存储器地址输出选择
always @(*) begin
  case (check_r[1])
    1'b0: 
	  m_rf_addr = {3'b000,cnt_m_rf};
    1'b1:
	  m_rf_addr = {in_r[4:2],cnt_m_rf};   
  endcase
end

//流水线寄存器数据选择输入
always @(*)begin
  case (cnt_ah_plr)
  //PC/IF/ID
  2'b00:
      case (cnt_al_plr[1:0])
      2'b00: plr_data = pc;
      2'b01: plr_data = pcd;
      2'b10: plr_data = ir;
      //2'b11: plr_data = pcin;
      default : plr_data = pc;
      endcase
   //ID/EX 
   2'b01:
   begin
      case (cnt_al_plr)
      //3'b000: plr_data = pce;
      3'b001: plr_data = a;
      3'b010: plr_data = b;
      //3'b011: plr_data = imm;
      3'b100: plr_data = {{27{1'b0}},rd};
      3'b101: plr_data = ctrl;
      default: plr_data = a;
      endcase
    end
    //EX/MEM
    2'b10:
      case (cnt_al_plr[1:0])
      2'b00: plr_data = y;
      2'b01: plr_data = bm;
      2'b10: plr_data = {{27{1'b0}},rdm};
      2'b11: plr_data = ctrlm;
      default : plr_data = y;
      endcase
    //MEM/WB
    2'b11:
      case (cnt_al_plr[1:0])
      2'b00: plr_data = yw;
      //2'b01: plr_data = mdr;
      2'b10: plr_data = {{27{1'b0}},rdw};
      2'b11: plr_data = ctrlw;
      default : plr_data = yw;
      endcase
    endcase
end

//LED和数码管查看类型
always @(posedge clk, posedge rst) begin
if(rst)
    check_r <= 2'b00;            
  else if(run_r)
    check_r <= 2'b00;
  else if (step_p)
    check_r <= 2'b00;
  else if (valid_pn)
    check_r <= check - 2'b01;
end

//LED和数码管显示内容
always @(*)begin
  case (check_r)
    2'b00: begin
      out0_a = out0_r;
      out1_a = out1_r;
    end
    2'b01: begin
      out0_a = cnt_m_rf;
      out1_a = rf_data;
    end
    2'b10: begin
      out0_a = cnt_m_rf;
      out1_a = m_data;
    end
    2'b11: begin
      out0_a = addr_plr;
      out1_a = plr_data;    //更改为流水线寄存器地址和数据显示
    end
  endcase
end

//扫描数码管
always @(posedge clk, posedge rst) begin
  if (rst) cnt <= 20'h0_0000;
  else cnt <= cnt + 20'h0_0001;
end

always @* begin
  case (an)
    3'd0: seg_a = out1_a[3:0];
    3'd1: seg_a = out1_a[7:4];
    3'd2: seg_a = out1_a[11:8];
    3'd3: seg_a = out1_a[15:12];
    3'd4: seg_a = out1_a[19:16];
    3'd5: seg_a = out1_a[23:20];
    3'd6: seg_a = out1_a[27:24];
    3'd7: seg_a = out1_a[31:28];
    default: ;
  endcase
end

endmodule
