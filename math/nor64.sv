`timescale 1ns/10ps

module nor64 (
   output logic        out,
   input  logic [63:0] in
);

   parameter DELAY = 0.05;

   logic [15:0] t0;
   logic  [3:0] t1;

   and #DELAY aOut (out, t1[3], t1[2], t1[1], t1[0]);

   genvar i;
   generate
      for (i = 0; i < 16; i++) begin : nors
         nor #DELAY n (t0[i], in[4*i], in[4*i+1], in[4*i+2], in[4*i+3]);
      end

      for (i = 0; i < 4; i++) begin : ands
         and #DELAY a (t1[i], t0[4*i], t0[4*i+1], t0[4*i+2], t0[4*i+3]);
      end
   endgenerate
endmodule

module nor64_testbench ();
   logic        out;
   logic [63:0] in;

   nor64 dut (.out, .in);

   initial begin
      in = 64'h0000_0000_0000_0000; #10; assert(out == 1'b1);
      in = 64'h0000_0000_0000_0001; #10; assert(out == 1'b0);
      repeat(63) begin
         in = in << 1; #10; assert(out == 1'b0);
      end

      in = 64'h0000_0000_0000_0003; #10; assert(out == 1'b0);
      repeat(62) begin
         in = in << 1; #10; assert(out == 1'b0);
      end

      in = 64'h0000_0000_0000_0007; #10; assert(out == 1'b0);
      repeat(61) begin
         in = in << 1; #10; assert(out == 1'b0);
      end
   end
endmodule
