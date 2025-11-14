`timescale 1ns/1ps
module tb_vga_timing;
  reg clk=0; localparam real TCLK=40.0; always #(TCLK/2.0) clk=~clk;
  reg reset=1; initial begin #200; reset=0; end
  wire [9:0] x; wire [9:0] y; wire hs; wire vs; wire blank_n;
  vga_timing_640x480 dut(.clk(clk),.reset(reset),.x(x),.y(y),.hs(hs),.vs(vs),.blank_n(blank_n));

  localparam H_VISIBLE=640, H_FRONT=16, H_SYNC=96, H_BACK=48, H_TOTAL=800;
  localparam V_VISIBLE=480, V_FRONT=10, V_SYNC=2, V_BACK=33, V_TOTAL=525;

  integer hs_low,h_cycle,vs_low,lines_this_frame;

  task check_one_line;
    begin
      @(negedge hs);
      hs_low=0; h_cycle=0;
      while(hs==1'b0) begin @(posedge clk); hs_low=hs_low+1; end
      while(hs==1'b1) begin @(posedge clk); h_cycle=h_cycle+1; end
      if(hs_low!==H_SYNC) $fatal(1,"HS_low=%0d exp=%0d",hs_low,H_SYNC);
      if((hs_low+h_cycle)!==H_TOTAL) $fatal(1,"H_total=%0d exp=%0d",hs_low+h_cycle,H_TOTAL);
    end
  endtask

  task check_one_frame;
    begin
      @(negedge vs);
      vs_low=0; lines_this_frame=0;
      while(vs==1'b0) begin check_one_line(); vs_low=vs_low+1; end
      while(vs==1'b1) begin check_one_line(); lines_this_frame=lines_this_frame+1; if(lines_this_frame>V_TOTAL) disable check_one_frame; end
      if(vs_low!==V_SYNC) $fatal(1,"VS_low=%0d exp=%0d",vs_low,V_SYNC);
      if((vs_low+lines_this_frame)!==V_TOTAL) $fatal(1,"V_total=%0d exp=%0d",vs_low+lines_this_frame,V_TOTAL);
      $display("[OK] one frame passed");
    end
  endtask

  initial begin
    @(negedge reset);
    repeat(100) @(posedge clk);
    check_one_frame();
    check_one_frame();
    $display("done");
    $stop;
  end
endmodule
