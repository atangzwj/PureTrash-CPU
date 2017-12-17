`timescale 1ns/10ps

module busMux4_1 #(parameter WIDTH = 64) (
   output logic      [WIDTH - 1 : 0] out,
   input  logic [3:0][WIDTH - 1 : 0] in,
   input  logic              [1 : 0] sel
);

   genvar i;
   generate
      for (i = 0; i < WIDTH; i++) begin : muxes
         logic [3:0] slice; // Store the ith bit of each input bus
         assign slice = {in[3][i], in[2][i], in[1][i], in[0][i]};
         mux4_1 m (.out(out[i]), .in(slice), .sel);
      end
   endgenerate
endmodule

module busMux4_1_testbench ();
   logic      [15:0] out;
   logic [3:0][15:0] in;
   logic       [1:0] sel;

   busMux4_1 #(.WIDTH(16)) dut (.out, .in, .sel);

   integer i;
   initial begin
      in[0] = 16'h0123;
      in[1] = 16'h4567;
      in[2] = 16'h89AB;
      in[3] = 16'hCDEF;

      for (i = 0; i < 4; i++) begin
         sel = i; #10; assert(out == in[i]);
      end
      
      in = ~in;
      for (i = 0; i < 4; i++) begin
         sel = i; #10; assert(out == in[i]);
      end
   end
endmodule
