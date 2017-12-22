`timescale 1ns/10ps

module alu4 (
   output logic [3:0] aluOut,
   output logic       cOut,
   output logic       pg,
   output logic       gg,
   input  logic [3:0] A,
   input  logic [3:0] B,
   input  logic       cIn,
   input  logic [2:0] ctrl
);

   logic [3:0] p, g, c;
   assign c[0] = cIn;

   genvar i;
   generate
      for (i = 0; i < 4; i++) begin : alus
         alu1 alu1 (
            .aluOut(aluOut[i]),
            .p(p[i]),
            .g(g[i]),
            .A(A[i]),
            .B(B[i]),
            .cIn(c[i]),
            .ctrl
         );
      end
   endgenerate

   lcu u (.pg, .gg, .cOut, .c(c[3:1]), .p, .g, .cIn);
endmodule

module alu4_testbench ();
   logic [3:0] aluOut;
   logic       cOut, pg, gg;
   logic [3:0] A, B;
   logic       cIn;
   logic [2:0] ctrl;

   alu4 dut (.aluOut, .cOut, .pg, .gg, .A, .B, .cIn, .ctrl);
   parameter
   ALU_PASS_B   = 3'b000,
   ALU_ADD      = 3'b010,
   ALU_SUBTRACT = 3'b011,
   ALU_AND      = 3'b100,
   ALU_OR       = 3'b101,
   ALU_XOR      = 3'b110;

   initial begin
      ctrl = ALU_PASS_B;
      A = 4'hA; B = 4'hC; #10; assert(aluOut == B);
      A = ~A;   B = ~B;   #10; assert(aluOut == B);

      cIn = 1'b0;
      ctrl = ALU_ADD;
      A = 4'h1; B = 4'h1; #10; // Simple addition
      assert(aluOut == 4'h2 && cOut == 1'b0);

      A = 4'h7; B = 4'h1; #10; // Carry to top bit
      assert(aluOut == 4'h8 && cOut == 1'b0);

      A = 4'hF; B = 4'h1; #10; // Carry through
      assert(aluOut == 4'h0 && cOut == 1'b1);

      A = 4'hC; B = 4'h4; #10; // Carry out
      assert(aluOut == 4'h0 && cOut == 1'b1);

      A = 4'hA; B = 4'h6; #10; // Sum to 0
      assert(aluOut == 4'h0 && cOut == 1'b1);

      A = 4'hF; B = 4'hF; #10; // Largest inputs
      assert(aluOut == 4'hE && cOut == 1'b1);
   end
endmodule
