`timescale 1ns/10ps

module register #(parameter WIDTH = 64) (
   output logic [WIDTH - 1 : 0] dOut,
   input  logic [WIDTH - 1 : 0] wrData,
   input  logic                 wrEn,
   input  logic                 reset,
   input  logic                 clk
);

   logic [WIDTH - 1 : 0] dIn;
   genvar i;
   generate
      // Muxes select between new data and old values
      // D_ffs hold data
      for (i = 0; i < WIDTH; i++) begin : ffs
         mux2_1 mux (.out(dIn[i]), .in0(dOut[i]), .in1(wrData[i]), .sel(wrEn));
         d_ff dff (.q(dOut[i]), .d(dIn[i]), .reset, .clk);
      end
   endgenerate
endmodule

module register_testbench ();
   logic [23:0] dOut;
   logic [23:0] wrData;
   logic        wrEn;
   logic        reset;
   logic        clk;

   register #(.WIDTH(24)) dut (.dOut, .wrData, .wrEn, .reset, .clk);

   parameter CLK_PER = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PER / 2) clk <= ~clk;
   end

   initial begin
      reset <= 1'b0;
      wrData <= 24'h000000; wrEn <= 1'b0; @(posedge clk);
      wrData <= 24'h0000FF; wrEn <= 1'b1; @(posedge clk);
                            wrEn <= 1'b0; @(posedge clk);
                                          @(posedge clk);
                                          @(posedge clk);
                                          @(posedge clk);
      wrData <= 24'h00FF00;               @(posedge clk);
                                          @(posedge clk);
                                          @(posedge clk);
                            wrEn <= 1'b1; @(posedge clk);
                            wrEn <= 1'b0; @(posedge clk);
                                          @(posedge clk);
                                          @(posedge clk);
      wrData <= 24'hFF0000; wrEn <= 1'b1; @(posedge clk);
                            wrEn <= 1'b0; @(posedge clk);
      wrData <= 24'hCACACA; wrEn <= 1'b1; @(posedge clk);
                            wrEn <= 1'b0; @(posedge clk);
                                          @(posedge clk);
                                          @(posedge clk);
                                          @(posedge clk);
      reset <= 1'b1;                      @(posedge clk);
      reset <= 1'b0;                      @(posedge clk);
      $stop;
   end
endmodule
