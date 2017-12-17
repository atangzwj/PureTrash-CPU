`timescale 1ns/10ps

module mux2_1 (
   output logic out,
   input  logic in0,
   input  logic in1,
   input  logic sel
);

   parameter DELAY = 0.05;

   logic seln;
   not #DELAY n (seln, sel);

   logic out0, out1;
   and #DELAY a0 (out0, in0, seln);
   and #DELAY a1 (out1, in1, sel);

   or #DELAY o (out, out0, out1);
endmodule

module mux2_1_testbench ();
   logic out;
   logic in0, in1, sel;

   mux2_1 dut (.out, .in0, .in1, .sel);

   integer i;
   initial begin
      for (i = 0; i < 8; i++) begin
         {sel, in1, in0} = i; #10;
      end
   end
endmodule
