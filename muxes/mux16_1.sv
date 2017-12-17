`timescale 1ns/10ps

module mux16_1 (
   output logic        out,
   input  logic [15:0] in,
   input  logic  [3:0] sel
);

   logic out0, out1
   mux8_1 m0 (.out(out0), .in(in[7:0]),  .sel(sel[2:0]));
   mux8_1 m1 (.out(out1), .in(in[15:8]), .sel(sel[2:0]));

   mux2_1 mOut (.out, .in0(out0), .in1(out1), .sel(sel[3]));
endmodule

module mux16_1_testbench ();
   logic        out;
   logic [15:0] in;
   logic  [3:0] sel;

   mux16_1 dut (.out, .in, .sel);

   integer i;
   initial begin
      in = 16'h39CA;
      for (i = 0; i < 16; i++) begin
         sel = i; #10;
         assert(out == in[i]);
      end
   end
endmodule
