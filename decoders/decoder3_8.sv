`timescale 1ns/10ps

module decoder3_8 (
   output [7:0] d,
   input  [2:0] sel,
   input        en
);

   parameter DELAY = 0.05;

   logic [2:0] seln;
   not #DELAY n0 (seln[0], sel[0]);
   not #DELAY n1 (seln[1], sel[1]);
   not #DELAY n2 (seln[2], sel[2]);

   and #DELAY d0 (d[0], en, seln[2], seln[1], seln[0]);
   and #DELAY d1 (d[1], en, seln[2], seln[1], sel[0]);
   and #DELAY d2 (d[2], en, seln[2], sel[1],  seln[0]);
   and #DELAY d3 (d[3], en, seln[2], sel[1],  sel[0]);
   and #DELAY d4 (d[4], en, sel[2],  seln[1], seln[0]);
   and #DELAY d5 (d[5], en, sel[2],  seln[1], sel[0]);
   and #DELAY d6 (d[6], en, sel[2],  sel[1],  seln[0]);
   and #DELAY d7 (d[7], en, sel[2],  sel[1],  sel[0]);
endmodule

module decoder3_8_testbench ();
   logic [7:0] d;
   logic [2:0] sel;
   logic       en;

   decoder3_8 dut (.d, .sel, .en);

   integer i;
   initial begin
      en = 1'b0;
      for (i = 0; i < 8; i++) begin
         sel = i; #10;
      end
      sel = 2'b00;
      en = 1'b1;
      for (i = 0; i < 8; i++) begin
         sel = i; #10;
      end
   end
endmodule
