`timescale 1ns/10ps

module mux8_1 (
   output logic       out,
   input  logic [7:0] in,
   input  logic [2:0] sel
);

   parameter DELAY = 0.05;

   logic [2:0] seln;
   not #DELAY n0 (seln[0], sel[0]);
   not #DELAY n1 (seln[1], sel[1]);
   not #DELAY n2 (seln[2], sel[2]);

   logic [7:0] mid0;
   and #DELAY a0 (mid0[0], in[0], seln[2], seln[1], seln[0]);
   and #DELAY a1 (mid0[1], in[1], seln[2], seln[1], sel[0]);
   and #DELAY a2 (mid0[2], in[2], seln[2], sel[1],  seln[0]);
   and #DELAY a3 (mid0[3], in[3], seln[2], sel[1],  sel[0]);
   and #DELAY a4 (mid0[4], in[4], sel[2],  seln[1], seln[0]);
   and #DELAY a5 (mid0[5], in[5], sel[2],  seln[1], sel[0]);
   and #DELAY a6 (mid0[6], in[6], sel[2],  sel[1],  seln[0]);
   and #DELAY a7 (mid0[7], in[7], sel[2],  sel[1],  sel[0]);

   logic [1:0] mid1;
   or #DELAY o0 (mid1[0], mid0[0], mid0[1], mid0[2], mid0[3]);
   or #DELAY o1 (mid1[1], mid0[4], mid0[5], mid0[6], mid0[7]);

   or #DELAY o2 (out, mid1[0], mid1[1]);
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
         assert(out == in[i]);
      end

      in = ~in;
      for (i = 0; i < 8; i++) begin
         sel = i; #10;
         assert(out == in[i]);
      end
   end
endmodule
