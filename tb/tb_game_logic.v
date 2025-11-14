`timescale 1ns/1ps
module tb_game_logic;
  reg clk=0; always #10 clk=~clk;
  reg reset=1; initial begin #200; reset=0; end

  reg move_left=0, move_right=0, move_up=0, move_down=0;
  reg rotate_block=0, place_block=0;
  reg sel1=0, sel2=0, sel3=0;

  wire [63:0] game_grid;
  wire [7:0] score;
  wire game_over;
  wire [63:0] block1,block2,block3;
  wire [2:0] block1_x,block1_y,block2_x,block2_y,block3_x,block3_y;

  game_logic dut(
    .clk(clk),.reset(reset),
    .move_left(move_left),.move_right(move_right),.move_up(move_up),.move_down(move_down),
    .rotate_block(rotate_block),.place_block(place_block),
    .sel1(sel1),.sel2(sel2),.sel3(sel3),
    .game_grid(game_grid),.score(score),.game_over(game_over),
    .block1(block1),.block2(block2),.block3(block3),
    .block1_x(block1_x),.block1_y(block1_y),
    .block2_x(block2_x),.block2_y(block2_y),
    .block3_x(block3_x),.block3_y(block3_y)
  );

  task pulse(input integer which);
    begin
      case(which)
        1: begin sel1=1; @(posedge clk); sel1=0; end
        2: begin sel2=1; @(posedge clk); sel2=0; end
        3: begin sel3=1; @(posedge clk); sel3=0; end
        4: begin move_left=1; @(posedge clk); move_left=0; end
        5: begin move_right=1; @(posedge clk); move_right=0; end
        6: begin move_up=1; @(posedge clk); move_up=0; end
        7: begin move_down=1; @(posedge clk); move_down=0; end
        8: begin rotate_block=1; @(posedge clk); rotate_block=0; end
        9: begin place_block=1; @(posedge clk); place_block=0; end
      endcase
    end
  endtask

  initial begin
    @(negedge reset);
    repeat(5) @(posedge clk);
    pulse(1);
    pulse(5); pulse(5); pulse(5);
    pulse(8);
    pulse(9);
    repeat(50) @(posedge clk);
    $display("score=%0d over=%0d grid=%016h_%016h_%016h_%016h",
             score,game_over,
             game_grid[63:48],game_grid[47:32],game_grid[31:16],game_grid[15:0]);
    $stop;
  end
endmodule
