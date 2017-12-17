`timescale 1ns/10ps

module mux2_1 (
   output logic out,
   input  logic i0,
   input  logic i1,
   input  logic sel
);

   parameter DELAY = 0.05;

   logic seln;
   not #DELAY n (seln, sel);

   logic out0, out1;
   and #DELAY a0 (out0, i0, seln);
   and #DELAY a1 (out1, i1, sel);

   or #DELAY o (out, out0, out1);
endmodule

module mux2_1_testbench ();
   logic out;
   logic i0, i1, sel;

   mux2_1 dut (.out, .i0, .i1, .sel);

   integer i;
   initial begin
      for (i = 0; i < 8; i++) begin
         {sel, i1, i0} = i; #10;
      end
   end
endmodule
