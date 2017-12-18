`timescale 1ns/10ps

module regfile (
   output logic [63:0] readData0,
   output logic [63:0] readData1,
   input  logic [63:0] writeData,
   input  logic  [4:0] readReg0,
   input  logic  [4:0] readReg1,
   input  logic  [4:0] writeReg,
   input  logic        regWrEn,
   input  logic        clk
);

   // One bit in regSelect will be true to enable writing to one register
   logic [31:0] regSelect;
   decoder5_32 dec (.d(regSelect), .sel(writeReg), .en(regWrEn));

   // gprConcat holds output of the 32 data registers
   // Register 31 assigned to be 0
   logic [31:0][63:0] gprConcat;
   assign gprConcat[31] = 64'b0;
   genvar i;
   generate
      for (i = 0; i < 31; i++) begin : gpr
         register #(.WIDTH(64)) gpr (
            .dOut(gprConcat[i]),
            .wrData(writeData),
            .wrEn(regSelect[i]),
            .reset(1'b0),
            .clk
         );
      end
   endgenerate

   // Use muxes to select which register to read from
   busMux32_1 #(.WIDTH(64)) rdData0Mux (
      .out(readData0),
      .in(gprConcat),
      .sel(readReg0)
   );

   busMux32_1 #(.WIDTH(64)) rdData1Mux (
      .out(readData1),
      .in(gprConcat),
      .sel(readReg1) 
   );
endmodule
