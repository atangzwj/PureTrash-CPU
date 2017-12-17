`timescale 1ns/10ps

module mux8_1 (
   output logic       out,
   input  logic [7:0] in,
   input  logic [2:0] sel
);

   logic out0, out1;
   mux4_1 m0 (.out(out0), .in(in[3:0]), .sel(sel[1:0]));
   mux4_1 m1 (.out(out1), .in(in[7:4]), .sel(sel[1:0]));

   mux2_1 mOut (.out, .i0(out0), .i1(out1), .sel(sel[2]));
endmodule

module mux8_1_testbench ();
   logic       out;
   logic [7:0] in;
   logic [2:0] sel;

   mux8_1 dut (.out, .in, .sel);

   integer i;
   initial begin
      in = 8'hCA;
      for (i = 0; i < 8; i++) begin
         sel = i; #10;
      end

      in = ~in;
      for (i = 0; i < 8; i++) begin
         sel = i; #10;
      end
   end
endmodule
