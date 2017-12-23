`timescale 1ns/10ps

module alu16 (
   output logic [15:0] aluOut,
   output logic        cOut,
   output logic        cInMSB,
   output logic        pg,
   output logic        gg,
   input  logic [15:0] A,
   input  logic [15:0] B,
   input  logic        cIn,
   input  logic  [2:0] ctrl
);

   logic [3:0] p, g, c, cInsMSB;
   assign c[0] = cIn;

   assign cInMSB = cInsMSB[3];

   genvar i;
   generate
      for (i = 0; i < 4; i++) begin : alus
         alu4 alu4 (
            .aluOut(aluOut[(4*i+3):(4*i)]),
            .cOut(),
            .cInMSB(cInsMSB[i]),
            .pg(p[i]),
            .gg(g[i]),
            .A(A[(4*i+3):(4*i)]),
            .B(B[(4*i+3):(4*i)]),
            .cIn(c[i]),
            .ctrl
         );
      end
   endgenerate

   lcu u (.pg, .gg, .cOut, .c(c[3:1]), .p, .g, .cIn);
endmodule

module alu16_testbench ();
   logic [15:0] aluOut;
   logic        cOut, pg, gg;
   logic [15:0] A, B;
   logic        cIn;
   logic  [2:0] ctrl;

   alu16 dut (.aluOut, .cOut, .pg, .gg, .A, .B, .cIn, .ctrl);

   parameter
   ALU_PASS_B   = 3'b000,
   ALU_ADD      = 3'b010,
   ALU_SUBTRACT = 3'b011,
   ALU_AND      = 3'b100,
   ALU_OR       = 3'b101,
   ALU_XOR      = 3'b110;

   assign cIn = ctrl[0];
   initial begin
      ctrl = ALU_PASS_B;
      A = 16'hAAAA; B = 16'hCCCC; #10; assert(aluOut == B);
      A = ~A;       B = ~B;       #10; assert(aluOut == B);

      ctrl = ALU_ADD;
      A = 16'h0001; B = 16'h0001; #10; // Simple addition
      assert(aluOut == 16'h0002 && cOut == 1'b0);

      A = 16'h7FFF; B = 16'h0001; #10; // Carry to top bit
      assert(aluOut == 16'h8000 && cOut == 1'b0);

      A = 16'hFFFF; B = 16'h0001; #10; // Carry through
      assert(aluOut == 16'h0000 && cOut == 1'b1);

      A = 16'hC000; B = 16'h4CA8; #10; // Carry out
      assert(aluOut == 16'h0CA8 && cOut == 1'b1);

      A = 16'hCCAA; B = 16'h3356; #10; // Sum to 0
      assert(aluOut == 16'h0000 && cOut == 1'b1);

      A = 16'hFFFF; B = 16'hFFFF; #10; // Largest inputs
      assert(aluOut == 16'hFFFE && cOut == 1'b1);

      ctrl = ALU_SUBTRACT;
      A = 16'hCCAA; B = 16'hCCAA; #10;
      assert(aluOut == 16'h0000 && cOut == 1'b1);

      A = 16'hCCCC; B = 16'hAAAA; #10;
      assert(aluOut == 16'h2222 && cOut == 1'b1);

      A = 16'hAAAA; B = 16'hCCCC; #10;
      assert(aluOut == 16'hDDDE && cOut == 1'b0);

      ctrl = ALU_AND;
      A = 16'h0000; B = 16'h0000; #10;
      assert(aluOut == (A & B));

      A = 16'hFFFF; B = 16'hFFFF; #10;
      assert(aluOut == (A & B));

      A = 16'hAAAA; B = 16'h5555; #10;
      assert(aluOut == (A & B));

      ctrl = ALU_OR;
      A = 16'h0000; B = 16'h0000; #10;
      assert(aluOut == (A | B));

      A = 16'hFFFF; B = 16'hFFFF; #10;
      assert(aluOut == (A | B));

      A = 16'hAAAA; B = 16'h5555; #10;
      assert(aluOut == (A | B));

      ctrl = ALU_XOR;
      A = 16'h0000; B = 16'h0000; #10;
      assert(aluOut == (A ^ B));

      A = 16'hFFFF; B = 16'hFFFF; #10;
      assert(aluOut == (A ^ B));

      A = 16'hAAAA; B = 16'h5555; #10;
      assert(aluOut == (A ^ B));
   end
endmodule
