// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fullchip (clk, mem_in, inst, reset, out);

parameter col = 8;
parameter bw = 8;
parameter bw_psum = 2*bw+4;
parameter pr = 8;

input  clk; 
input  [pr*bw-1:0] mem_in; 
input  [18:0] inst; 
input  reset;
output [col*bw_psum-1:0] out;

wire [bw_psum+3:0] sum_out;

wire [bw_psum+3:0] sum_in;
wire sfp_sum_fifo_rd;

assign sum_in = {(bw_psum+4){1'b0}};
assign sfp_sum_fifo_rd = 1'b1;

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance (
      .reset(reset), 
      .clk(clk), 
      .mem_in(mem_in), 
      .inst(inst),
      .out(out),
      .sum_out(sum_out),
      .sfp_sum_fifo_rd(sfp_sum_fifo_rd),
      .sum_in(sum_in)
);

endmodule
