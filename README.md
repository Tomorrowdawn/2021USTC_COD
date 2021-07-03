# 2021USTC_COD
2021年中科大(USTC)计算机组成原理(COD)综合实验,带三级浮点流水的五级RISCV流水线

本代码遵循[GPL3.0](https://www.gnu.org/licenses/gpl-3.0.html)协议.~~另外,请不要试图抄袭本代码完成实验~~

在RTL文件夹中可以获取所有源文件,测试文件以及样例.注意,IP核并未在其中,请自行生成.本CPU在100MHZ时钟FPGA上正常工作,实现了`fsub,fadd,fmul,fsw,ld,sw,add,addi,beq,jal`十条指令.并且,本CPU采取了分支前移,解决了所有可能冲突情况,最极端情况下只需要一次停顿.

关于设计细节,请自行阅读源代码,配合vivado的RTL生成电路理解.
