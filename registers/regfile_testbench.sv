`timescale 1ns/10ps

module regfile_testbench ();
   // Outputs
   logic [63:0] readData0;
   logic [63:0] readData1;

   // Inputs
   logic [63:0] writeData;
   logic  [4:0] readReg0;
   logic  [4:0] readReg1;
   logic  [4:0] writeReg;
   logic        regWrEn;
   logic        clk;

   regfile dut (
      .readData0,
      .readData1,
      .writeData,
      .readReg0,
      .readReg1,
      .writeReg,
      .regWrEn,
      .clk
   );

   parameter CLK_PER = 5000;
   initial begin
      clk <= 0;
      forever #(CLK_PER / 2) clk <= ~clk;
   end

   // Print %t's in a nice format
   initial $timeformat(-9, 2, " ns", 10);

   initial begin
      // Try to write the value 0xA0 into register 31.
      // Register 31 should always be 0
      writeData <= 64'h0000_0000_0000_00A0;
      writeReg  <= 5'd31;
      readReg0  <= 5'd0;
      readReg1  <= 5'd0;
      regWrEn   <= 1'b0;
      @(posedge clk);
      
      $display("%t Writing to X31, which should always be 0", $time);
      regWrEn <= 1'b1;
      @(posedge clk);

      // Write a value into each register
      $display("%t Writing pattern to all registers.", $time);
      for (i = 0; i < 31; i++) begin
         regWrEn   <= 1'b0;
         readReg0  <= i - 1;
         readReg1  <= i;
         writeReg  <= i;
         writeData <= i * 64'h0000010204080001;
         @(posedge clk);
         
         regWrEn <= 1'b1;
         @(posedge clk);
      end

      // Verify that the registers retained the data
      $display("%t Checking pattern.", $time);
      for (i = 0; i < 32; i++) begin
         regWrEn   <= 1'b0;
         readReg0  <= i - 1;
         readReg1  <= i;
         writeReg  <= i;
         writeData <= i * 64'h0000000000000100 + i;
         @(posedge clk);
      end
      $stop;
   end
endmodule
