`timescale 1ns/10ps

module busMux2_1 #(parameter WIDTH = 64) (
   output logic [WIDTH - 1 : 0] out,
   input  logic [WIDTH - 1 : 0] in0,
   input  logic [WIDTH - 1 : 0] in1,
   input  logic                 sel
);

   genvar i;
   generate
      for (i = 0; i < WIDTH; i++) begin : muxes
         mux2_1 m (.out(out[i]), .i0(in0[i]), .i1(in1[i]), .sel);
      end
   endgenerate
endmodule

module busMux2_1_testbench ();
   logic [15:0] out;
   logic [15:0] in0;
   logic [15:0] in1;
   logic        sel;

   busMux2_1 #(.WIDTH(16)) dut (.out, .in0, .in1, .sel);

   initial begin
      in0  = 16'hCA35;
      in1  = 16'hE6F2;
      sel = 1'b0; #10;
      sel = 1'b1; #10;

      in0 = ~in0;
      in1 = ~in1;
      sel = 1'b0; #10;
      sel = 1'b1; #10;
   end
endmodule
