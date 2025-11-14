transcript on
quit -sim
vlib ../work
vmap work ../work
vlog -work work ../src/vga_timing_640x480.v
vlog -work work ../src/vga_controller.v
vlog -work work ./tb_vga_controller.v
vsim -voptargs=+acc work.tb_vga_controller
add wave -r sim:/tb_vga_controller/*
add wave -r sim:/tb_vga_controller/dut/*
add wave -r sim:/tb_vga_controller/dut/T/*
run -all
