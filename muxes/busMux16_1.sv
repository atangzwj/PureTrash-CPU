`timescale 1ns/10ps

module busMux16_1 #(parameter WIDTH = 64) (
   output logic       [WIDTH - 1 : 0] out,
   input  logic [15:0][WIDTH - 1 : 0] in,
   input  logic               [3 : 0] sel
);

   logic [3:0][WIDTH - 1 : 0] mid;
   busMux4_1 #(.WIDTH(WIDTH)) m0 (.out(mid[0]), .in(in[3:0]),   .sel(sel[1:0]));
   busMux4_1 #(.WIDTH(WIDTH)) m1 (.out(mid[1]), .in(in[7:4]),   .sel(sel[1:0]));
   busMux4_1 #(.WIDTH(WIDTH)) m2 (.out(mid[2]), .in(in[11:8]),  .sel(sel[1:0]));
   busMux4_1 #(.WIDTH(WIDTH)) m3 (.out(mid[3]), .in(in[15:12]), .sel(sel[1:0]));

   busMux4_1 #(.WIDTH(WIDTH)) mOut (.out, .in(mid), .sel(sel[3:2]));
endmodule

module busMux16_1_testbench ();
   logic       [7:0] out;
   logic [15:0][7:0] in;
   logic       [3:0] sel;

   busMux16_1 #(.WIDTH(8)) dut (.out, .in, .sel);

   integer i;
   initial begin
      in[0]  = 8'h80; in[1]  = 8'h98; in[2]  = 8'hFF; in[3]  = 8'hDE;
      in[4]  = 8'h9C; in[5]  = 8'h13; in[6]  = 8'hC5; in[7]  = 8'h30;
      in[8]  = 8'hCC; in[9]  = 8'h7F; in[10] = 8'hE9; in[11] = 8'h47;
      in[12] = 8'hD6; in[13] = 8'h6C; in[14] = 8'h3D; in[15] = 8'hCA;

      for (i = 0; i < 16; i++) begin
         sel = i; #10; assert(out == in[i]);
      end

      in = ~in;
      for (i = 0; i < 16; i++) begin
         sel = i; #10; assert(out == in[i]);
      end
   end
endmodule
