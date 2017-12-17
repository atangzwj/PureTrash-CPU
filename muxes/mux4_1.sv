`timescale 1ns/10ps

module mux4_1 (
   output logic       out,
   input  logic [3:0] in,
   input  logic [1:0] sel
);

   parameter DELAY = 0.05;

   logic [1:0] seln;
   not #DELAY n0 (seln[0], sel[0]);
   not #DELAY n1 (seln[1], sel[1]);

   logic out0, out1, out2, out3;
   and #DELAY a0 (out0, in[0], seln[1], seln[0]);
   and #DELAY a1 (out1, in[1], seln[1], sel[0]);
   and #DELAY a2 (out2, in[2], sel[1],  seln[0]);
   and #DELAY a3 (out3, in[3], sel[1],  sel[0]);

   or #DELAY o (out, out0, out1, out2, out3);
endmodule

module mux4_1_testbench ();
   logic       out;
   logic [3:0] in;
   logic [1:0] sel;

   mux4_1 dut (.out, .in, .sel);

   integer i;
   initial begin
      for (i = 0; i < 64; i++) begin
         {sel, in} = i; #10;
      end
   end
endmodule
