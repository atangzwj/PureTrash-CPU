`timescale 1ns/10ps

module cla64 (
   output logic [63:0] s,
   output logic        cOut,
   output logic        pg,
   output logic        gg,
   input  logic [63:0] a,
   input  logic [63:0] b,
   input  logic        cIn
);

   logic [3:0] p, g, c;
   assign c[0] = cIn;

   genvar i;
   generate
      for (i = 0; i < 4; i++) begin : adders
         cla16 adder (
            .s(s[(16*i+15):(16*i)]),
            .cOut(),
            .pg(p[i]),
            .gg(g[i]),
            .a(a[(16*i+15):(16*i)]),
            .b(b[(16*i+15):(16*i)]),
            .cIn(c[i])
         );
      end
   endgenerate

   lcu u (.pg, .gg, .cOut, .c(c[3:1]), .p, .g, .cIn);
endmodule

module cla64_testbench ();
   logic [63:0] s;
   logic        cOut, pg, gg;
   logic [63:0] a, b;
   logic        cIn;

   cla64 dut (.s, .cOut, .pg, .gg, .a, .b, .cIn);

   initial begin
      cIn = 1'b0;
      a = 64'h0000000000000001; // Simple addition
      b = 64'h0000000000000001; #10; 
      a = 64'h7FFFFFFFFFFFFFFF; // Carry to top bit
      b = 64'h0000000000000001; #10;
      a = 64'hFFFFFFFFFFFFFFFF; // Carry through
      b = 64'h0000000000000001; #10;
      a = 64'hFFFFFFFFFFFF0000; // Carry out
      b = 64'h000000000001CCAA; #10;
      a = 64'hCCCCCCCCCCCCCCCC; // Sum to 0
      b = 64'h3333333333333334; #10;
      a = 64'hFFFFFFFFFFFFFFFF; // Largest inputs
      b = 64'hFFFFFFFFFFFFFFFF; #10;

      cIn = 1'b1;
      a = 64'h0000000000000001; // Simple addition
      b = 64'h0000000000000001; #10; 
      a = 64'h7FFFFFFFFFFFFFFE; // Carry to top bit
      b = 64'h0000000000000001; #10;
      a = 64'hFFFFFFFFFFFFFFFE; // Carry through
      b = 64'h0000000000000001; #10;
      a = 64'hCFFFFFFFFFFF0000; // Carry out
      b = 64'h000000000001CCA9; #10;
      a = 64'hCCCCCCCCCCCCCCCC; // Sum to 0
      b = 64'h3333333333333333; #10;
      a = 64'hFFFFFFFFFFFFFFFF; // Largest inputs
      b = 64'hFFFFFFFFFFFFFFFF; #10;
   end
endmodule
