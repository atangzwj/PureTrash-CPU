`timescale 1ns/10ps

module d_ff (
   output logic q,
   input  logic d,
   input  logic reset,
   input  logic clk
);

   always_ff @ (posedge clk) begin
      if (reset) q <= 0;
      else       q <= d;
   end
endmodule
