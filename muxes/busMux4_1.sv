`timescale 1ns/10ps

module busMux4_1 #(parameter WIDTH = 64) (
   output logic      [WIDTH - 1 : 0] out,
   input  logic [3:0][WIDTH - 1 : 0] in,
   input  logic              [1 : 0] sel
);

   logic [WIDTH - 1 : 0] out0, out1;
   busMux2_1 #(.WIDTH(WIDTH)) bm0 (
      .out(out0),
      .in0(in[0]),
      .in1(in[1]),
      .sel(sel[0])
   );
   busMux2_1 #(.WIDTH(WIDTH)) bm1 (
      .out(out1),
      .in0(in[2]),
      .in1(in[3]),
      .sel(sel[0])
   );

   busMux2_1 #(.WIDTH(WIDTH)) bmOut (
      .out,
      .in0(out0),
      .in1(out1),
      .sel(sel[1])
   );
endmodule

module busMux4_1_testbench ();
   logic      [15:0] out;
   logic [3:0][15:0] in;
   logic       [1:0] sel;

   busMux4_1 #(.WIDTH(16)) dut (.out, .in, .sel);

   integer i;
   initial begin
      in[0] = 16'h0123;
      in[1] = 16'h4567;
      in[2] = 16'h89AB;
      in[3] = 16'hCDEF;

      for (i = 0; i < 4; i++) begin
         sel = i; #10;
      end
   end
endmodule
