`timescale 1ns/10ps

module spg (
   output logic s,
   output logic p,
   output logic g,
   input  logic a,
   input  logic b,
   input  logic c
);

   parameter DELAY = 0.05;

   xor #DELAY sum (s, p, c);
   xor #DELAY pro (p, a, b);
   and #DELAY gen (g, a, b);
endmodule

module spg_testbench ();
   logic s, p, g;
   logic a, b, c;

   spg dut (.s, .p, .g, .a, .b, .c);

   integer i;
   initial begin
      for (i = 0; i < 8; i++) begin
         {a, b, c} = i; #10;
         assert({g, p} == a + b); assert(s == a ^ b ^ c);
      end
   end
endmodule
