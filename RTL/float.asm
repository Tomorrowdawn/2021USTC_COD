.text
    lw      x9, 0(x0)       #get io base address
ready1:
    lw      x6, 16(x9)      #read valid
    beq     x6, x0, ready1  #if valid==1 then read data1
ADD:
    fadd.s  f4,f0,f1
    fsw     f4, 8(x9)       #display f4
wating1:    
    lw      x6, 16(x9)      #read valid
    beq     x6, x0, SUB  #if valid==0 then data1 read done
    jal     x8, wating1
SUB: 
    lw      x6, 16(x9)      #read valid
    beq     x6, x0, SUB
    fsub.s  f5, f1, f2      #read data_in
    fsw     f5, 8(x9)       #display f5
wating2:    
    lw      x6, 16(x9)      #read valid
    beq     x6, x0, MUL	    #if valid==0 then data1 read done
    jal     x8, wating2
MUL:
    fmul.s  f7,f2,f2
    fsw     f7,8(x9)
end: jal x7,end
.data
    0x400

//f0 = 0.5
//f1 = 0.3
//f2 = -5.5