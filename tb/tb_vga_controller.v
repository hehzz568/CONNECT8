`timescale 1ns/1ps
module tb_vga_controller;
  reg clk=0; always #20 clk=~clk;
  reg reset=1; initial begin #200; reset=0; end

  reg [63:0] game_grid=64'h0000_0000_0000_0001;
  reg [63:0] block1=64'h0, block2=64'h0, block3=64'h0;
  reg [2:0]  block1_x=0, block1_y=0, block2_x=0, block2_y=0, block3_x=0, block3_y=0;
  reg [7:0]  score=0;
  reg        game_over=0;

  wire [7:0] vga_r,vga_g,vga_b;
  wire vga_hs,vga_vs,vga_blank_n;

  vga_controller dut(
    .clk(clk),.reset(reset),
    .game_grid(game_grid),
    .block1(block1),.block2(block2),.block3(block3),
    .block1_x(block1_x),.block1_y(block1_y),
    .block2_x(block2_x),.block2_y(block2_y),
    .block3_x(block3_x),.block3_y(block3_y),
    .score(score),.game_over(game_over),
    .vga_r(vga_r),.vga_g(vga_g),.vga_b(vga_b),
    .vga_hs(vga_hs),.vga_vs(vga_vs),.vga_blank_n(vga_blank_n)
  );

  integer cnt_nonblack=0;
  always @(posedge clk) if(vga_blank_n && (|vga_r || |vga_g || |vga_b)) cnt_nonblack<=cnt_nonblack+1;

  initial begin
    repeat(300000) @(posedge clk);
    $display("nonblack=%0d",cnt_nonblack);
    if(cnt_nonblack==0) $fatal(1,"no colored pixel");
    $finish;
  end
endmodule

