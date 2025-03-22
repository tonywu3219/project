module mac_8in (clk, reset, out, a, b);

parameter bw = 8;
parameter bw_psum = 2*bw+6;
parameter pr = 64; // parallel factor: number of inputs = 64

input  clk, reset;
output reg [bw_psum-1:0] out;
input  [pr*bw-1:0] a;
input  [pr*bw-1:0] b;

reg [2*bw-1:0] product_reg [7:0]; 
reg [bw_psum-1:0] sum_reg;         

always @(posedge clk or posedge reset) begin
  if (reset) begin
    product_reg[0] <= 0;
    product_reg[1] <= 0;
    product_reg[2] <= 0;
    product_reg[3] <= 0;
    product_reg[4] <= 0;
    product_reg[5] <= 0;
    product_reg[6] <= 0;
    product_reg[7] <= 0;
  end else begin
    product_reg[0] <= {{(bw){a[bw*1-1]}}, a[bw*1-1:bw*0]} * {{(bw){b[bw*1-1]}}, b[bw*1-1:bw*0]};
    product_reg[1] <= {{(bw){a[bw*2-1]}}, a[bw*2-1:bw*1]} * {{(bw){b[bw*2-1]}}, b[bw*2-1:bw*1]};
    product_reg[2] <= {{(bw){a[bw*3-1]}}, a[bw*3-1:bw*2]} * {{(bw){b[bw*3-1]}}, b[bw*3-1:bw*2]};
    product_reg[3] <= {{(bw){a[bw*4-1]}}, a[bw*4-1:bw*3]} * {{(bw){b[bw*4-1]}}, b[bw*4-1:bw*3]};
    product_reg[4] <= {{(bw){a[bw*5-1]}}, a[bw*5-1:bw*4]} * {{(bw){b[bw*5-1]}}, b[bw*5-1:bw*4]};
    product_reg[5] <= {{(bw){a[bw*6-1]}}, a[bw*6-1:bw*5]} * {{(bw){b[bw*6-1]}}, b[bw*6-1:bw*5]};
    product_reg[6] <= {{(bw){a[bw*7-1]}}, a[bw*7-1:bw*6]} * {{(bw){b[bw*7-1]}}, b[bw*7-1:bw*6]};
    product_reg[7] <= {{(bw){a[bw*8-1]}}, a[bw*8-1:bw*7]} * {{(bw){b[bw*8-1]}}, b[bw*8-1:bw*7]};
  end
end

always @(posedge clk or posedge reset) begin
  if (reset) begin
    sum_reg <= 0;
  end else begin
    sum_reg <= 
      {{(4){product_reg[0][2*bw-1]}}, product_reg[0]} +
      {{(4){product_reg[1][2*bw-1]}}, product_reg[1]} +
      {{(4){product_reg[2][2*bw-1]}}, product_reg[2]} +
      {{(4){product_reg[3][2*bw-1]}}, product_reg[3]} +
      {{(4){product_reg[4][2*bw-1]}}, product_reg[4]} +
      {{(4){product_reg[5][2*bw-1]}}, product_reg[5]} +
      {{(4){product_reg[6][2*bw-1]}}, product_reg[6]} +
      {{(4){product_reg[7][2*bw-1]}}, product_reg[7]};
  end
end

assign out = sum_reg;

endmodule
