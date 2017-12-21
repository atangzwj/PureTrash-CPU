`timescale 1ns/10ps

module lcu (
   output logic       pg,
   output logic       gg,
   output logic       cOut,
   output logic [3:1] c,
   input  logic [3:0] p,
   input  logic [3:0] g,
   input  logic       cIn
);

   parameter DELAY = 0.05;

   // c1 = g0 + c0p0
   logic t0;
   and #DELAY a0 (t0, cIn, p[0]);
   or  #DELAY o0 (c[1], g[0], t0);

   // c2 = g1 + g0p1 + c0p0p1
   logic t1, t2;
   and #DELAY a1 (t1, cIn, p[0], p[1]);
   and #DELAY a2 (t2, g[0], p[1]);
   or  #DELAY o1 (c[2], g[1], t2, t1);

   // c3 = g2 + g1p2 + g0p1p2 + c0p0p1p2
   logic t3, t4, t5;
   and #DELAY a3 (t3, cIn, p[0], p[1], p[2]);
   and #DELAY a4 (t4, g[0], p[1], p[2]);
   and #DELAY a5 (t5, g[1], p[2]);
   or  #DELAY o2 (c[3], g[2], t5, t4, t3);

   // gg = g3 + g2p3 + g1p2p3 + g0p1p2p3
   // pg = p0p1p2p3
   // c4 = g3 + g2p3 + g1p2p3 + g0p1p2p3 + c0p0p1p2p3 = gg + c0pg
   logic t6, t7, t8;
   and #DELAY a6 (t6, g[0], p[1], p[2], p[3]);
   and #DELAY a7 (t7, g[1], p[2], p[3]);
   and #DELAY a8 (t8, g[2], p[3]);
   or  #DELAY o3 (gg, g[3], t8, t7, t6);

   and #DELAY a9 (pg, p[0], p[1], p[2], p[3]);

   and #DELAY aX (tX, c[0], pg);
   or  #DELAY o4 (cOut, gg, tX);
endmodule

module lcu_testbench ();
   logic       pg, gg, cOut;
   logic [3:1] c;
   logic [3:0] p, g;
   logic       cIn;

   lcu dut (.pg, .gg, .cOut, .c, .p, .g, .cIn);

   integer i, j;
   initial begin
      for (i = 0; i < 32; i++) begin
         for (j = 0; j < 16; j++) begin
            {cIn, p} <= i; g <= j; #10;
         end
      end
   end
endmodule
