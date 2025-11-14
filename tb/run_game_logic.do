transcript on
quit -sim
vlib ../work
vmap work ../work
vlog -work work ../src/game_logic.v
vlog -work work ../src/block_generator.v
vlog -work work ./tb_game_logic.v
vsim -voptargs=+acc work.tb_game_logic
add wave -r sim:/tb_game_logic/*
add wave -r sim:/tb_game_logic/dut/*
run -all
