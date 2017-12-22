`timescale 1ns/10ps

// ctrl  Operation               Notes:
// -----------------------------------------------------------------------------
// 000:  aluOut = B              value of overflow and carryOut unimportant
// 010:  aluOut = A + B
// 011:  aluOut = A - B
// 100:  aluOut = bitwise A & B  value of overflow and carryOut unimportant
// 101:  aluOut = bitwise A | B  value of overflow and carryOut unimportant
// 110:  aluOut = bitwise A ^ B  value of overflow and carryOut unimportant

module alu1 (
   output logic       aluOut,
   output logic       p,
   output logic       g,
   input  logic       A,
   input  logic       B,
   input  logic       cIn,
   input  logic [2:0] ctrl
);

   parameter DELAY = 0.05;

   logic sum, bAdd;
   xor #DELAY bSel (bAdd, B, ctrl[0]); // When subtracting, invert B
   spg adder (.s(sum), .p, .g, .a(A), .b(bAdd), .c(cIn));

   logic andOut, orrOut, xorOut;
   and #DELAY a0 (andOut, A, B);
   or  #DELAY o0 (orrOut, A, B);
   xor #DELAY x0 (xorOut, A, B);

   logic [7:0] toMux;
   assign toMux[0] = B;
   assign toMux[2] = sum;
   assign toMux[3] = sum;
   assign toMux[4] = andOut;
   assign toMux[5] = orrOut;
   assign toMux[6] = xorOut;

   mux8_1 m (.out(aluOut), .in(toMux), .sel(ctrl));
endmodule

module alu1_testbench ();
   logic       aluOut, p, g;
   logic       A, B, cIn;
   logic [2:0] ctrl;

   alu1 dut (.aluOut, .p, .g, .A, .B, .cIn, .ctrl);

   parameter
   ALU_PASS_B   = 3'b000,
   ALU_ADD      = 3'b010,
   ALU_SUBTRACT = 3'b011,
   ALU_AND      = 3'b100,
   ALU_OR       = 3'b101,
   ALU_XOR      = 3'b110;

   integer i;
   initial begin
      ctrl = ALU_PASS_B;
      for (i = 0; i < 8; i++) begin
         {cIn, A, B} = i; #10;
      end

      ctrl = ALU_ADD;
      for (i = 0; i < 8; i++) begin
         {cIn, A, B} = i; #10;
      end

      ctrl = ALU_SUBTRACT;
      for (i = 0; i < 8; i++) begin
         {cIn, A, B} = i; #10;
      end

      ctrl = ALU_AND;
      for (i = 0; i < 8; i++) begin
         {cIn, A, B} = i; #10;
      end

      ctrl = ALU_OR;
      for (i = 0; i < 8; i++) begin
         {cIn, A, B} = i; #10;
      end

      ctrl = ALU_XOR;
      for (i = 0; i < 8; i++) begin
         {cIn, A, B} = i; #10;
      end
   end
endmodule
