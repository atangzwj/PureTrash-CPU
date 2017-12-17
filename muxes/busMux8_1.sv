`timescale 1ns/10ps

module busMux8_1 #(parameter WIDTH = 64) (
   output logic      [WIDTH - 1 : 0] out,
   input  logic [7:0][WIDTH - 1 : 0] in,
   input  logic              [2 : 0] sel
);

   genvar i, j;
   generate
      for (i = 0; i < WIDTH; i++) begin : muxes
         logic [7:0] slice; // Store the ith bit of each input bus
         for (j = 0; j < 8; j++) begin : getSlice
            assign slice[j] = in[j][i];
         end
         mux8_1 m (.out(out[i]), .in(slice), .sel);
      end
   endgenerate
endmodule

module busMux8_1_testbench ();
   logic      [15:0] out;
   logic [7:0][15:0] in;
   logic       [2:0] sel;

   busMux8_1 #(.WIDTH(16)) dut (.out, .in, .sel);

   integer i;
   initial begin
      in[0] = 16'h1736;
      in[1] = 16'h0D6B;
      in[2] = 16'hDC8D;
      in[3] = 16'h1C3A;
      in[4] = 16'h98E4;
      in[5] = 16'h3AB4;
      in[6] = 16'h864A;
      in[7] = 16'hCA88;

      for (i = 0; i < 8; i++) begin
         sel = i; #10; assert(out == in[i]);
      end

      in = ~in;
      for (i = 0; i < 8; i++) begin
         sel = i; #10; assert(out == in[i]);
      end
   end
endmodule
