`timescale 1ns/10ps

module fullAdder (
   output logic sum,
   output logic cOut,
   input  logic a,
   input  logic b,
   input  logic cIn
);

   parameter DELAY = 0.05;

   logic s0, c0, c1;
   halfAdder ha0 (.sum(s0), .cOut(c0), .a, .b);

   halfAdder ha1 (.sum, .cOut(c1), .a(s0), .b(cIn));

   or #DELAY o (cOut, c0, c1);
endmodule

module fullAdder_testbench ();
   logic sum, cOut, a, b, cIn;

   fullAdder dut (.sum, .cOut, .a, .b, .cIn);

   integer i;
   initial begin
      for (i = 0; i < 8; i++) begin
         {a, b, cIn} = i; #10; assert({cOut, sum} == a + b + cIn);
      end
   end
endmodule
