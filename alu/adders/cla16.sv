`timescale 1ns/10ps

module cla16 (
   output logic [15:0] s,
   output logic        cOut,
   output logic        pg,
   output logic        gg,
   input  logic [15:0] a,
   input  logic [15:0] b,
   input  logic        cIn
);

   logic [3:0] p, g, c;
   assign c[0] = cIn;

   genvar i;
   generate
      for (i = 0; i < 4; i++) begin : adders
         cla4 adder (
            .s(s[(4*i+3):(4*i)]),
            .cOut(),
            .pg(p[i]),
            .gg(g[i]),
            .a(a[(4*i+3):(4*i)]),
            .b(b[(4*i+3):(4*i)]),
            cIn(c[i])
         );
      end
   endgenerate

   lcu u (.pg, .gg, .cOut, .c(c[3:1]), .p, .g, .cIn);
endmodule

module cla16_testbench ();
   logic [15:0] s;
   logic        cOut, pg, gg;
   logic [15:0] a, b;
   logic        cIn;

   cla16 dut (.s, .cOut, .pg, .gg, .a, .b, .cIn);

   initial begin
      a = 16'h0001; b = 16'h0001; #10; // Simple addition
      a = 16'h7FFF; b = 16'h0001; #10; // Carry to top bit
      a = 16'hFFFF; b = 16'h0001; #10; // Carry through
      a = 16'hC000; b = 16'h4CA8; #10; // Carry out
      a = 16'hCCCC; b = 16'h4445; #10; // Sum to 0
   end
endmodule
