`timescale 1ns/10ps

module mux16_1 (
   output logic        out,
   input  logic [15:0] in,
   input  logic  [3:0] sel
);

   logic [3:0] mid;
   mux4_1 m0 (.out(mid[0]), .in(in[3:0]),   .sel(sel[1:0]));
   mux4_1 m1 (.out(mid[1]), .in(in[7:4]),   .sel(sel[1:0]));
   mux4_1 m2 (.out(mid[2]), .in(in[11:8]),  .sel(sel[1:0]));
   mux4_1 m3 (.out(mid[3]), .in(in[15:12]), .sel(sel[1:0]));

   mux4_1 mOut (.out, .in(mid), .sel(sel[3:2]));
endmodule

module mux16_1_testbench ();
   logic        out;
   logic [15:0] in;
   logic  [3:0] sel;

   mux16_1 dut (.out, .in, .sel);

   integer i;
   initial begin
      in = 16'h39CA;
      for (i = 0; i < 16; i++) begin
         sel = i; #10; assert(out == in[i]);
      end

      in = ~in;
      for (i = 0; i < 16; i++) begin
         sel = i; #10; assert(out == in[i]);
      end
   end
endmodule
