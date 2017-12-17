`timescale 1ns/10ps

module mux32_1 (
   output logic        out,
   input  logic [31:0] in,
   input  logic  [4:0] sel
);

   logic [3:0] mid;
   mux8_1 m0 (.out(mid[0]), .in(in[7:0]),   .sel(sel[2:0]));
   mux8_1 m1 (.out(mid[1]), .in(in[15:8]),  .sel(sel[2:0]));
   mux8_1 m2 (.out(mid[2]), .in(in[23:16]), .sel(sel[2:0]));
   mux8_1 m3 (.out(mid[3]), .in(in[31:24]), .sel(sel[2:0]));

   mux4_1 mOut (.out, .in(mid), .sel(sel[4:3]));
endmodule

module mux32_1_testbench ();
   logic        out;
   logic [31:0] in;
   logic  [4:0] sel;

   mux32_1 dut (.out, .in, .sel);

   integer i;
   initial begin
      in = 32'hCA88_F0C3;
      for (i = 0; i < 32; i++) begin
         sel = i; #10; assert(out == in[i]);
      end

      in = ~in;
      for (i = 0; i < 32; i++) begin
         sel = i; #10; assert(out == in[i]);
      end
   end
endmodule
