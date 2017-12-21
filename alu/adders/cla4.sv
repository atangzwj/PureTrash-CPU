`timescale 1ns/10ps

module cla4 (
   output logic [3:0] s,
   output logic       cOut,
   output logic       pg,
   output logic       gg,
   input  logic [3:0] a,
   input  logic [3:0] b
   input  logic       cIn
);

   logic [3:0] p, g, c;
   assign c[0] = cIn;

   genvar i;
   generate
      for (i = 0; i < 4; i++) begin : adders
         spg adder (.s(s[i]), .p(p[i]), .g(g[i]), .a(a[i]), .b(b[i]), .c(c[i]));
      end
   endgenerate

   lcu u (.pg, .gg, .cOut, .c(c[3:1]), .p, .g, .cIn);
endmodule

module cla4_testbench ();
   logic [3:0] s;
   logic       pg, gg;
   logic [3:0] a, b;
   logic       cIn;

   cla4 dut (.s, .pg, .gg, .a, .b, .cIn);

   integer i, j;
   initial begin
      for (i = 0; i < 16; i++) begin
         for (j = 0; j < 16; j++) begin
            a = i; b = j; #10; assert(s == a + b);
         end
      end
   end
endmodule
