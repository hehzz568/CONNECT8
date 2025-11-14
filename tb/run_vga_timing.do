transcript on
quit -sim
vlib ../work
vmap work ../work
vlog -work work ../src/vga_timing_640x480.v
vlog -work work ./tb_vga_timing.v
vsim -voptargs=+acc work.tb_vga_timing
add wave -r sim:/tb_vga_timing/*
add wave -r sim:/tb_vga_timing/dut/*
run -all
