`timescale 1ns/10ps

module alu64 (
   output logic [63:0] aluOut,
   output logic        cOut,
   output logic        pg,
   output logic        gg,
   input  logic [63:0] A,
   input  logic [63:0] B,
   input  logic        cIn,
   input  logic  [2:0] ctrl
);

   logic [3:0] p, g, c;
   assign c[0] = cIn;

   genvar i;
   generate
      for (i = 0; i < 4; i++) begin : alus
         alu16 alu16 (
            .aluOut(aluOut[(16*i+15):(16*i)]),
            .cOut(),
            .pg(p[i]),
            .gg(g[i]),
            .A(A[(16*i+15):(16*i)]),
            .B(B[(16*i+15):(16*i)]),
            .cIn(c[i]),
            .ctrl
         );
      end
   endgenerate

   lcu u (.pg, .gg, .cOut, .c(c[3:1]), .p, .g, .cIn);
endmodule

module alu64_testbench ();
   logic [63:0] aluOut;
   logic        cOut, pg, gg;
   logic [63:0] A, B;
   logic        cIn;
   logic  [2:0] ctrl;

   alu64 dut (.aluOut, .cOut, .pg, .gg, .A, .B, .cIn, .ctrl);

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
      A = 64'hAAAA_3456_CA33_EECC;
      B = 64'hCCAA_CA88_BCAA_BA88; #10; assert(aluOut == B);
      A = ~A;       B = ~B;        #10; assert(aluOut == B);

      ctrl = ALU_ADD;
      A = 64'h0000_0000_0000_0001; // Simple addition
      B = 64'h0000_0000_0000_0001; #10;
      assert(aluOut == 64'h0000_0000_0000_0002 && cOut == 1'b0);

      A = 64'h7FFF_FFFF_FFFF_FFFF; // Carry to top bit
      B = 64'h0000_0000_0000_0001; #10;
      assert(aluOut == 64'h8000_0000_0000_0000 && cOut == 1'b0);

      A = 64'hFFFF_FFFF_FFFF_FFFF; // Carry through
      B = 64'h0000_0000_0000_0001; #10;
      assert(aluOut == 64'h0000_0000_0000_0000 && cOut == 1'b1);

      A = 64'hFFFF_CCAA_BCBC_88CA; // Carry out
      B = 64'h0000_4CA8_0000_0000; #10;
      assert(aluOut == 64'h0000_1952_BCBC_88CA && cOut == 1'b1);

      A = 64'hCCAA_BCBC_CA88_BA88; // Sum to 0
      B = 64'h3355_4343_3577_4578; #10;
      assert(aluOut == 64'h0000_0000_0000_0000 && cOut == 1'b1);

      A = 64'hFFFF_FFFF_FFFF_FFFF; // Largest inputs
      B = 64'hFFFF_FFFF_FFFF_FFFF; #10;
      assert(aluOut == 64'hFFFF_FFFF_FFFF_FFFE && cOut == 1'b1);

      ctrl = ALU_SUBTRACT;
      A = 64'hCCAA_CA88_BCAA_BA88;
      B = 64'hCCAA_CA88_BCAA_BA88; #10;
      assert(aluOut == 64'h0000_0000_0000_0000 && cOut == 1'b1);

      A = 64'hCCCC_BCBC_88CA_88BA;
      B = 64'hAAAA_3456_CA33_EECC; #10;
      assert(aluOut == 64'h2222_8865_BE96_99EE && cOut == 1'b1);

      ctrl = ALU_AND;
      A = 64'h0000_0000_0000_0000;
      B = 64'h0000_0000_0000_0000; #10;
      assert(aluOut == (A & B));

      A = 64'hFFFF_FFFF_FFFF_FFFF;
      B = 64'hFFFF_FFFF_FFFF_FFFF; #10;
      assert(aluOut == (A & B));

      A = 64'hAAAA_AAAA_AAAA_AAAA;
      B = 64'h5555_5555_5555_5555; #10;
      assert(aluOut == (A & B));

      ctrl = ALU_OR;
      A = 64'h0000_0000_0000_0000;
      B = 64'h0000_0000_0000_0000; #10;
      assert(aluOut == (A | B));

      A = 64'hFFFF_FFFF_FFFF_FFFF;
      B = 64'hFFFF_FFFF_FFFF_FFFF; #10;
      assert(aluOut == (A | B));

      A = 64'hAAAA_AAAA_AAAA_AAAA;
      B = 64'h5555_5555_5555_5555; #10;
      assert(aluOut == (A | B));

      ctrl = ALU_XOR;
      A = 64'h0000_0000_0000_0000;
      B = 64'h0000_0000_0000_0000; #10;
      assert(aluOut == (A ^ B));

      A = 64'hFFFF_FFFF_FFFF_FFFF;
      B = 64'hFFFF_FFFF_FFFF_FFFF; #10;
      assert(aluOut == (A ^ B));

      A = 64'hAAAA_AAAA_AAAA_AAAA;
      B = 64'h5555_5555_5555_5555; #10;
      assert(aluOut == (A ^ B));
   end
endmodule
