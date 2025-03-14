// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 

`timescale 1ns / 1ps

module fullchip_tb;

  parameter total_cycle = 8;  // how many streamed Q vectors will be processed
  parameter bw = 8;  // Q & K vector bit precision
  parameter bw_psum = 2 * bw + 4;  // partial sum bit precision
  parameter pr = 8;  // how many products added in each dot product 
  parameter col = 8;  // how many dot product units are equipped

  integer qk_file;  // file handler
  integer qk_scan_file;  // file handler


  integer captured_data;
  integer weight[col*pr-1:0];
  `define NULL 0


  integer K[2*col-1:0][pr-1:0];
  integer Q[total_cycle-1:0][pr-1:0];
  reg signed [bw_psum-1:0] result[total_cycle-1:0][2*col-1:0];
  reg signed [bw_psum-1:0] abs_result[total_cycle-1:0][2*col-1:0];
  reg signed [bw_psum+4-1:0] sum_core0[total_cycle-1:0];
  reg signed [bw_psum+4-1:0] sum_core1[total_cycle-1:0];

  integer i, j, k, t, p, q, s, u, m;


  wire [2*col*bw_psum-1:0] out;
  reg reset = 1;
  reg clk = 0;
  reg [pr*bw-1:0] mem_in_core0;
  reg [pr*bw-1:0] mem_in_core1;
  reg ofifo_rd = 0;
  wire [18:0] inst;
  reg qmem_rd = 0;
  reg qmem_wr = 0;
  reg kmem_rd = 0;
  reg kmem_wr = 0;
  reg pmem_rd = 0;
  reg pmem_wr = 0;
  reg execute = 0;
  reg load = 0;
  reg [3:0] qkmem_add = 0;
  reg [3:0] pmem_add = 0;
  reg acc = 0;
  reg div = 0;

  assign inst[18] = div;
  assign inst[17] = acc;
  assign inst[16] = ofifo_rd;
  assign inst[15:12] = qkmem_add;
  assign inst[11:8] = pmem_add;
  assign inst[7] = execute;
  assign inst[6] = load;
  assign inst[5] = qmem_rd;
  assign inst[4] = qmem_wr;
  assign inst[3] = kmem_rd;
  assign inst[2] = kmem_wr;
  assign inst[1] = pmem_rd;
  assign inst[0] = pmem_wr;



  reg [bw_psum-1:0] temp5b;
  reg [bw_psum+3:0] temp_sum;
  reg [bw_psum*col-1:0] temp16b;
  reg [bw_psum-1:0] norm_result;
  reg [bw_psum*col-1:0] norm;
  reg [2*bw_psum*col-1:0] f_result[total_cycle-1:0];


  fullchip #(
      .bw(bw),
      .bw_psum(bw_psum),
      .col(col),
      .pr(pr)
  ) fullchip_instance (
      .reset(reset),
      .clk(clk),
      .mem_in_core0(mem_in_core0),
      .mem_in_core1(mem_in_core1),
      .inst(inst),
      .out(out)
  );


  initial begin

    $dumpfile("fullchip_tb.vcd");
    $dumpvars(0, fullchip_tb);



    ///// Q data txt reading /////

    $display("##### Q data txt reading #####");

    qk_file = $fopen("qdata.txt", "r");

    for (q = 0; q < total_cycle; q = q + 1) begin
      for (j = 0; j < pr; j = j + 1) begin
        qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
        Q[q][j] = captured_data;
      end
    end
    /////////////////////////////////




    for (q = 0; q < 2; q = q + 1) begin
      #0.5 clk = 1'b0;
      #0.5 clk = 1'b1;
    end




    ///// K data txt reading /////

    $display("##### K data txt reading #####");

    for (q = 0; q < 10; q = q + 1) begin
      #0.5 clk = 1'b0;
      #0.5 clk = 1'b1;
    end
    reset   = 0;

    qk_file = $fopen("kdata.txt", "r");


    for (q = 0; q < 2 * col; q = q + 1) begin
      for (j = 0; j < pr; j = j + 1) begin
        qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
        K[q][j] = captured_data;
      end
    end
    /////////////////////////////////


    /////////////// Estimated result printing /////////////////


    $display("##### Estimated multiplication result CORE0  #####");

    for (t = 0; t < total_cycle; t = t + 1) begin
      for (q = 0; q < col; q = q + 1) begin
        result[t][q] = 0;
      end
    end

    for (t = 0; t < total_cycle; t = t + 1) begin
      for (q = 0; q < col; q = q + 1) begin
        for (k = 0; k < pr; k = k + 1) begin
          result[t][q] = result[t][q] + Q[t][k] * K[q][k];
        end

        temp5b  = result[t][q];
        temp16b = {temp16b[139:0], temp5b};
      end

      $display("prd @cycle%2d: %40h", t, temp16b);
    end

    for (t = 0; t < total_cycle; t = t + 1) begin
      sum_core0[t] = 0;
      norm = 0;
    end

    $display("##### Estimated sum result CORE0 #####");
    for (t = 0; t < total_cycle; t = t + 1) begin
      for (q = 0; q < col; q = q + 1) begin
        abs_result[t][q] = ((result[t][q] > 0) ? result[t][q] : -result[t][q]);
        sum_core0[t] = sum_core0[t] + abs_result[t][q];
      end
      $display("Prd @pmem_add %d = %h", t, sum_core0[t]);

    end

    //////////////////////////////////////////////


    $display("##### Estimated multiplication result CORE1  #####");

    for (t = 0; t < total_cycle; t = t + 1) begin
      for (q = col; q < 2 * col; q = q + 1) begin
        result[t][q] = 0;
      end
    end

    for (t = 0; t < total_cycle; t = t + 1) begin
      for (q = col; q < 2 * col; q = q + 1) begin
        for (k = 0; k < pr; k = k + 1) begin
          result[t][q] = result[t][q] + Q[t][k] * K[q][k];
        end

        temp5b  = result[t][q];
        temp16b = {temp16b[139:0], temp5b};
      end

      $display("prd @cycle%2d: %40h", t, temp16b);
    end

    for (t = 0; t < total_cycle; t = t + 1) begin
      sum_core1[t] = 0;
      norm = 0;
    end

    $display("##### Estimated sum result CORE1 #####");
    for (t = 0; t < total_cycle; t = t + 1) begin
      for (q = col; q < 2 * col; q = q + 1) begin
        abs_result[t][q] = ((result[t][q] > 0) ? result[t][q] : -result[t][q]);
        sum_core1[t] = sum_core1[t] + abs_result[t][q];
      end
      $display("Prd @pmem_add %d = %h", t, sum_core1[t]);

    end

    $display("##### Estimated normalization result CORE0  #####");
    for (t = 0; t < total_cycle; t = t + 1) begin
      for (q = 0; q < col; q = q + 1) begin
        norm_result = {result[t][q], 8'b0} / (sum_core0[t] + sum_core1[t]);
        norm = {norm[139:0], norm_result};
      end
      f_result[t] = norm;
      $display("Prd @Cycle %d = %h", t, norm);
    end

    $display("##### Estimated normalization result CORE1 #####");
    for (t = 0; t < total_cycle; t = t + 1) begin
      for (q = col; q < 2 * col; q = q + 1) begin
        norm_result = {result[t][q], 8'b0} / (sum_core0[t] + sum_core1[t]);
        norm = {norm[139:0], norm_result};
      end
      f_result[t] = {norm, f_result[t][bw_psum*col-1:0]};
      $display("Prd @Cycle %d = %h", t, norm);
    end

    //////////////////////////////////////////////


    ///// Qmem writing  /////

    $display("##### Qmem writing  #####");

    for (q = 0; q < total_cycle; q = q + 1) begin

      #0.5 clk = 1'b0;
      qmem_wr = 1;
      if (q > 0) qkmem_add = qkmem_add + 1;

      mem_in_core0[1*bw-1:0*bw] = Q[q][0];
      mem_in_core0[2*bw-1:1*bw] = Q[q][1];
      mem_in_core0[3*bw-1:2*bw] = Q[q][2];
      mem_in_core0[4*bw-1:3*bw] = Q[q][3];
      mem_in_core0[5*bw-1:4*bw] = Q[q][4];
      mem_in_core0[6*bw-1:5*bw] = Q[q][5];
      mem_in_core0[7*bw-1:6*bw] = Q[q][6];
      mem_in_core0[8*bw-1:7*bw] = Q[q][7];

      mem_in_core1[1*bw-1:0*bw] = Q[q][0];
      mem_in_core1[2*bw-1:1*bw] = Q[q][1];
      mem_in_core1[3*bw-1:2*bw] = Q[q][2];
      mem_in_core1[4*bw-1:3*bw] = Q[q][3];
      mem_in_core1[5*bw-1:4*bw] = Q[q][4];
      mem_in_core1[6*bw-1:5*bw] = Q[q][5];
      mem_in_core1[7*bw-1:6*bw] = Q[q][6];
      mem_in_core1[8*bw-1:7*bw] = Q[q][7];

      #0.5 clk = 1'b1;

    end


    #0.5 clk = 1'b0;
    qmem_wr   = 0;
    qkmem_add = 0;
    #0.5 clk = 1'b1;
    ///////////////////////////////////////////


    ///// Kmem writing  /////

    $display("##### Kmem writing #####");

    for (q = 0; q < col; q = q + 1) begin

      #0.5 clk = 1'b0;
      kmem_wr = 1;
      if (q > 0) qkmem_add = qkmem_add + 1;

      mem_in_core0[1*bw-1:0*bw] = K[q][0];
      mem_in_core0[2*bw-1:1*bw] = K[q][1];
      mem_in_core0[3*bw-1:2*bw] = K[q][2];
      mem_in_core0[4*bw-1:3*bw] = K[q][3];
      mem_in_core0[5*bw-1:4*bw] = K[q][4];
      mem_in_core0[6*bw-1:5*bw] = K[q][5];
      mem_in_core0[7*bw-1:6*bw] = K[q][6];
      mem_in_core0[8*bw-1:7*bw] = K[q][7];

      mem_in_core1[1*bw-1:0*bw] = K[q+col][0];
      mem_in_core1[2*bw-1:1*bw] = K[q+col][1];
      mem_in_core1[3*bw-1:2*bw] = K[q+col][2];
      mem_in_core1[4*bw-1:3*bw] = K[q+col][3];
      mem_in_core1[5*bw-1:4*bw] = K[q+col][4];
      mem_in_core1[6*bw-1:5*bw] = K[q+col][5];
      mem_in_core1[7*bw-1:6*bw] = K[q+col][6];
      mem_in_core1[8*bw-1:7*bw] = K[q+col][7];

      #0.5 clk = 1'b1;

    end

    #0.5 clk = 1'b0;
    kmem_wr   = 0;
    qkmem_add = 0;
    #0.5 clk = 1'b1;
    ///////////////////////////////////////////



    for (q = 0; q < 2; q = q + 1) begin
      #0.5 clk = 1'b0;
      #0.5 clk = 1'b1;
    end




    /////  K data loading  /////
    $display("##### K data loading to processor #####");

    for (q = 0; q < col + 1; q = q + 1) begin
      #0.5 clk = 1'b0;
      load = 1;
      if (q == 1) kmem_rd = 1;
      if (q > 1) begin
        qkmem_add = qkmem_add + 1;
      end

      #0.5 clk = 1'b1;
    end

    #0.5 clk = 1'b0;
    kmem_rd   = 0;
    qkmem_add = 0;
    #0.5 clk = 1'b1;

    #0.5 clk = 1'b0;
    load = 0;
    #0.5 clk = 1'b1;

    ///////////////////////////////////////////

    for (q = 0; q < 10; q = q + 1) begin
      #0.5 clk = 1'b0;
      #0.5 clk = 1'b1;
    end





    ///// execution  /////
    $display("##### execute #####");

    for (q = 0; q < total_cycle; q = q + 1) begin
      #0.5 clk = 1'b0;
      execute = 1;
      qmem_rd = 1;

      if (q > 0) begin
        qkmem_add = qkmem_add + 1;
      end

      #0.5 clk = 1'b1;
    end

    #0.5 clk = 1'b0;
    qmem_rd   = 0;
    qkmem_add = 0;
    execute   = 0;
    #0.5 clk = 1'b1;


    ///////////////////////////////////////////

    for (q = 0; q < 10; q = q + 1) begin
      #0.5 clk = 1'b0;
      #0.5 clk = 1'b1;
    end




    ////////////// output fifo rd and wb to psum mem ///////////////////

    $display("##### move ofifo to pmem #####");

    for (q = 0; q < total_cycle; q = q + 1) begin
      #0.5 clk = 1'b0;
      ofifo_rd = 1;
      pmem_wr  = 1;

      if (q > 0) begin
        pmem_add = pmem_add + 1;
      end

      #0.5 clk = 1'b1;
    end

    #0.5 clk = 1'b0;
    pmem_wr  = 0;
    pmem_add = 0;
    ofifo_rd = 0;
    #0.5 clk = 1'b1;

    ///////////////////////////////////////////

    for (q = 0; q < 10; q = q + 1) begin
      #0.5 clk = 1'b0;
      #0.5 clk = 1'b1;
    end

    ////////////// sfp accumulation ///////////////////

    $display("##### accumulation in sfp and wb to pmem #####");

    for (q = 0; q < total_cycle; q = q + 1) begin
      #0.5 clk = 1'b0;
      div = 0;
      pmem_rd = 1;
      pmem_wr = 0;
      if (q > 0) pmem_add = pmem_add + 1;
      #0.5 clk = 1'b1;

      #0.5 clk = 1'b0;
      acc = 1;
      pmem_rd = 0;
      #0.5 clk = 1'b1;

      #0.5 clk = 1'b0;
      acc = 0;
      #0.5 clk = 1'b1;

      #0.5 clk = 1'b0;
      div = 1;
      #0.5 clk = 1'b1;

      #0.5 clk = 1'b0;
      pmem_wr = 1;
      #0.5 clk = 1'b1;
    end

    #0.5 clk = 1'b0;
    pmem_rd = 0;
    pmem_add = 0;
    acc = 0;
    div = 0;
    pmem_wr = 0;
    #0.5 clk = 1'b1;

    ///////////////////////////////////////////

    #0.5 clk = 1'b0;
    div = 1;
    pmem_rd = 1;
    pmem_wr = 0;
    #0.5 clk = 1'b1;

    for (q = 0; q < total_cycle; q = q + 1) begin
      #0.5 clk = 1'b0;
      div = 1;
      pmem_rd = 1;
      pmem_wr = 0;
      pmem_add = pmem_add + 1;


      $display("out of @cycle %d: %h", q, out);
      $display("est of @cycle %d: %h", q, f_result[q]);
      #0.5 clk = 1'b1;
    end

    #10 $finish;


  end

endmodule
