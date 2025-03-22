/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : K-2015.06-SP2
// Date      : Thu Mar 20 17:45:22 2025
/////////////////////////////////////////////////////////////


module fullchip ( clk, mem_in_core0, mem_in_core1, inst, reset, out );
  input [63:0] mem_in_core0;
  input [63:0] mem_in_core1;
  input [18:0] inst;
  output [319:0] out;
  input clk, reset;

  tri   n_Logic1_;
  tri   clk;
  tri   [63:0] mem_in_core0;
  tri   [63:0] mem_in_core1;
  tri   [18:0] inst;
  tri   reset;
  tri   [319:0] out;
  tri   [23:0] core1_to_core0_sum_in;
  tri   [23:0] core0_to_core1_sum_out;

  core core_instance0 ( .reset(reset), .clk(clk), .mem_in(mem_in_core0), 
        .inst(inst), .sum_in(core1_to_core0_sum_in), .out(out[159:0]), 
        .sfp_sum_fifo_rd(1'b1), .sum_out(core0_to_core1_sum_out) );
  core core_instance1 ( .reset(reset), .clk(clk), .mem_in(mem_in_core1), 
        .inst(inst), .sum_in(core0_to_core1_sum_out), .out(out[319:160]), 
        .sfp_sum_fifo_rd(1'b1), .sum_out(core1_to_core0_sum_in) );
endmodule

