`timescale 1ns/10ps

module halfAdder (
   output logic sum,
   output logic cOut,
   input  logic a,
   input  logic b
);

   parameter DELAY = 0.05;

   xor #DELAY x (sum,  a, b);
   and #DELAY a (cOut, a, b);
endmodule

module halfAdder_testbench ();
   logic sum, cOut, a, b;

   halfAdder dut (.sum, .cOut, .a, .b);

   integer i;
   initial begin
      for (i = 0; i < 4; i++) begin
         {a, b} = i; #10; assert({cOut, sum} == a + b);
      end
   end
endmodule
