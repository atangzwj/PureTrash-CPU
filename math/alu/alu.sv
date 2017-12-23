`timescale 1ns/10ps

module alu (
   output logic [63:0] aluOut,
   output logic        negative,
   output logic        zero,
   output logic        overflow,
   output logic        carryOut,
   input  logic [63:0] A,
   input  logic [63:0] B,
   input  logic  [2:0] ctrl
);

   parameter DELAY = 0.05;

   logic cInMSB;

   alu64 alu64 (
      .aluOut,
      .cOut(carryOut),
      .cInMSB,
      .pg(),
      .gg(),
      .A,
      .B,
      .cIn(ctrl[0]),
      .ctrl
   );

   // Compute flags
   // Negative = MSB of result
   assign negative = aluOut[63];

   // Overflow = XOR of adder's MSB's carry-out and carry-in
   xor #DELAY x (overflow, carryOut, cInMSB);

   // Zero = 64bit NOR of result
   nor64 n (.out(zero), .in(aluOut));
endmodule
