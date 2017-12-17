`timescale 1ns/10ps

module busMux32_1 #(parameter WIDTH = 64) (
   output logic       [WIDTH - 1 : 0] out,
   input  logic [31:0][WIDTH - 1 : 0] in,
   input  logic               [4 : 0] sel
);

   logic [3:0][WIDTH - 1 : 0] mid;
   busMux8_1 #(.WIDTH(WIDTH)) m0 (.out(mid[0]), .in(in[7:0]),   .sel(sel[2:0]));
   busMux8_1 #(.WIDTH(WIDTH)) m1 (.out(mid[1]), .in(in[15:8]),  .sel(sel[2:0]));
   busMux8_1 #(.WIDTH(WIDTH)) m2 (.out(mid[2]), .in(in[23:16]), .sel(sel[2:0]));
   busMux8_1 #(.WIDTH(WIDTH)) m3 (.out(mid[3]), .in(in[31:24]), .sel(sel[2:0]));

   busMux4_1 #(.WIDTH(WIDTH)) mOut (.out, .in(mid), .sel(sel[4:3]));
endmodule

module busMux32_1_testbench ();
   logic       [11:0] out;
   logic [31:0][11:0] in;
   logic        [4:0] sel;

   busMux32_1 #(.WIDTH(12)) dut (.out, .in, .sel);

   integer i;
   initial begin
      in[0]  = 12'h760; in[1]  = 12'h5F1; in[2]  = 12'hC0E; in[3]  = 12'hC7C;
      in[4]  = 12'hC5A; in[5]  = 12'h93E; in[6]  = 12'h64A; in[7]  = 12'h87E;
      in[8]  = 12'hCFE; in[9]  = 12'h685; in[10] = 12'h25F; in[11] = 12'h17A;
      in[12] = 12'hBB8; in[13] = 12'h46F; in[14] = 12'hFFB; in[15] = 12'h9CB;
      in[16] = 12'h4E8; in[17] = 12'hC1A; in[18] = 12'h657; in[19] = 12'h234;
      in[20] = 12'hECF; in[21] = 12'h521; in[22] = 12'hE89; in[23] = 12'hBF2;
      in[24] = 12'h718; in[25] = 12'h1C4; in[26] = 12'hA3A; in[27] = 12'h86A;
      in[28] = 12'h89F; in[29] = 12'h2E3; in[30] = 12'h1EE; in[31] = 12'hCA8;

      for (i = 0; i < 64; i++) begin
         sel = i; #10; assert(out == in[i]);
      end

      in = ~in;
      for (i = 0; i < 64; i++) begin
         sel = i; #10; assert(out == in[i]);
      end
   end
endmodule
