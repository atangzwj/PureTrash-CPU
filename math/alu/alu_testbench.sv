`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: true when the ALU output is negative when interpreted as 2's comp
// zero:     true when the ALU output is 64-bit zero
// overflow: true on an add or subtract when the computation when the inputs
//           are interpreted as 2's comp
// carryOut: true on an add or subtract when the computation produces a
//           carry-out

// ctrl  Operation               Notes:
// -----------------------------------------------------------------------------
// 000:  aluOut = B              value of overflow and carryOut unimportant
// 010:  aluOut = A + B
// 011:  aluOut = A - B
// 100:  aluOut = bitwise A & B  value of overflow and carryOut unimportant
// 101:  aluOut = bitwise A | B  value of overflow and carryOut unimportant
// 110:  aluOut = bitwise A ^ B  value of overflow and carryOut unimportant

module alu_testbench ();
   // Outputs
   logic [63:0] aluOut;
   logic        negative, zero, overflow, carryOut;

   // Inputs
   logic [63:0] A, B;
   logic  [2:0] ctrl;

   alu dut (.aluOut, .negative, .zero, .overflow, .carryOut, .A, .B, .ctrl);

   parameter DELAY = 5000;

   parameter
   ALU_PASS_B   = 3'b000,
   ALU_ADD      = 3'b010,
   ALU_SUBTRACT = 3'b011,
   ALU_AND      = 3'b100,
   ALU_OR       = 3'b101,
   ALU_XOR      = 3'b110;

   // Print %t's in a nice format
   initial $timeformat(-9, 2, " ns", 10);

   integer i;
   initial begin
      $display("%t testing PASS_A operations", $time);
      ctrl = ALU_PASS_B;
      for (i=0; i<10; i++) begin
         A = $random(); B = $random();
         #(DELAY);
         assert(result == B && negative == B[63] && zero == (B == '0));
      end
      
      $display("%t testing addition", $time);
      ctrl = ALU_ADD;
      A = 64'h0000000000000001; B = 64'h0000000000000001;
      #(DELAY);
      assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0
            && negative == 0 && zero == 0);

      /* Our Test Cases */
      A = 64'h7FFFFFFFFFFFFFFF; B = 64'h0000000000000001; // Carry to top bit
      #(DELAY);
      assert(carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);      
      A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000001; // Carry through
      #(DELAY);
      assert(carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);      
      A = -64'd12; B = 64'd12; // Sum to 0
      #(DELAY);
      assert(result == 0 && carry_out == 1 && overflow == 0 && negative == 0
            && zero == 1);

      A = -64'd12; B = -64'd12; // Negative plus negative
      #(DELAY);
      assert(result == -64'd24 && carry_out == 1 && overflow == 0
            && negative == 1 && zero == 0);

      for (i = 0; i < 10; i++) begin
         A = $random(); B = $random();
         #(DELAY);
         assert(result == A + B);
      end
      
      $display("%t testing subtraction", $time);
      ctrl = ALU_SUBTRACT;
      A = 64'd0; B = 64'd0;
      #(DELAY);
      assert(result == 0 && carry_out == 1 && overflow == 0 && negative == 0
            && zero == 1);

      A = 64'd5; B = 64'd5;
      #(DELAY);
      assert(result == 0 && carry_out == 1 && overflow == 0 && negative == 0
            && zero == 1);

      A = 64'd5; B = -64'd5;
      #(DELAY);
      assert(result == 64'd10 && carry_out == 0 && overflow == 0
            && negative == 0 && zero == 0);

      A = 64'b1; B = 64'b1;
      #(DELAY);
      assert(result == 0 && carry_out == 1);

      for (i = 0; i < 10; i++) begin
         A = $random(); B = $random();
         #(DELAY);
         assert(result == A - B);
      end

      $display("%t testing and", $time);      
      ctrl = ALU_AND;

      A = 64'h0000000000000000;
      B = 64'h0000000000000000; #(DELAY);
      assert(result == (A & B));

      A = 64'hFFFFFFFFFFFFFFFF;
      B = 64'hFFFFFFFFFFFFFFFF; #(DELAY);
      assert(result == (A & B));

      A = 64'hAAAAAAAAAAAAAAAA;
      B = 64'h5555555555555555; #(DELAY);
      assert(result == (A & B));

      for (i=0; i<10; i++) begin
         A = $random(); B = $random();
         #(DELAY);
         assert(result == (A & B));
      end
      
      $display("%t testing or", $time);      
      ctrl = ALU_OR;

      A = 64'h0000000000000000;
      B = 64'h0000000000000000; #(DELAY);
      assert(result == (A | B));

      A = 64'hFFFFFFFFFFFFFFFF;
      B = 64'hFFFFFFFFFFFFFFFF; #(DELAY);
      assert(result == (A | B));

      A = 64'hAAAAAAAAAAAAAAAA;
      B = 64'h5555555555555555; #(DELAY);
      assert(result == (A | B));
      
      for (i=0; i<10; i++) begin
         A = $random(); B = $random();
         #(DELAY);
         assert(result == (A | B)); 
      end
      
      $display("%t testing xor", $time);      
      ctrl = ALU_XOR;

      A = 64'h0000000000000000;
      B = 64'h0000000000000000; #(DELAY);
      assert(result == (A ^ B));

      A = 64'hFFFFFFFFFFFFFFFF;
      B = 64'hFFFFFFFFFFFFFFFF; #(DELAY);
      assert(result == (A ^ B));

      A = 64'hAAAAAAAAAAAAAAAA;
      B = 64'h5555555555555555; #(DELAY);
      assert(result == (A ^ B));
      
      for (i=0; i<10; i++) begin
         A = $random(); B = $random();
         #(DELAY);
         assert(result == (A ^ B));
      end
      $stop;
   end
endmodule
