onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib insmem_opt

do {wave.do}

view wave
view structure
view signals

do {insmem.udo}

run -all

quit -force
