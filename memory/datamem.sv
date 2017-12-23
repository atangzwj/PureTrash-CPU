// Data memory. Supports reads and writes. Data initialized to "X". Note that
// this memory is little-endian:
// The value of the first double-word is
//    Mem[0]+Mem[1]*256+Mem[2]*256*256+ ... + Mem[7]*256^7
//
// Size is the number of bytes to transfer, and memory supports any power of 2
// access size up to double-word.
// However, all accesses must be aligned. So, the address of any access of size
// S must be a multiple of S.

`timescale 1ns/10ps

// How many bytes are in our memory?  Must be a power of 2
`define DATA_MEM_SIZE 1024

module datamem (
   output logic [63:0] readData,
   input  logic [63:0] addr,
   input  logic [63:0] writeData,
   input  logic        writeEnable,
   input  logic        readEnable,
   input  logic  [3:0] xferSize,
   input  logic        clk
);

   // Print %t's in a nice format
   initial $timeformat(-9, 2, " ns", 10);

   // Make sure size is a power of two and reasonable
   initial begin
      assert((`DATA_MEM_SIZE & (`DATA_MEM_SIZE - 1)) == 0);
      assert(`DATA_MEM_SIZE > 8);
   end

   // Make sure accesses are reasonable
   always_ff @ (posedge clk) begin
      // address or size could be all X's at startup, so ignore this case
      if (addr !== 'x && (writeEnable || readEnable)) begin
         // Makes sure address is aligned.
         assert((address & (xfer_size - 1)) == 0);

         // Make sure size is a power of 2
         assert((xfer_size & (xfer_size-1)) == 0);

         // Make sure address in bounds
         assert(address + xfer_size <= `DATA_MEM_SIZE);
      end
   end

   // The data storage itself
   logic [7:0] mem [`DATA_MEM_SIZE - 1 : 0];

   // Compute a properly aligned address
   logic [63:0] alignedAddr;
   always_comb begin
      case (xferSize)
         1:       alignedAddr =  address;
         2:       alignedAddr = {address[63:1], 1'b0};
         4:       alignedAddr = {address[63:2], 2'b00};
         8:       alignedAddr = {address[63:3], 3'b000};
         default: alignedAddr = {address[63:3], 3'b000};
         // Bad addresses forced to double-word aligned
      endcase
   end

   // Handle the reads
   integer i;
   always_comb begin
      readData = 'x;
      if (readEnable == 1) begin
         for(i = 0; i < xferSize; i++) begin
            readData[8*i+7 -: 8] = mem[alignedAddr + i];
            // 8*i+7 -: 8 means "start at 8*i+7, for 8 bits total"
         end
      end
   end

   // Handle the writes
   integer j;
   always_ff @ (posedge clk) begin
      if (writeEnable) begin
         for(j = 0; j < xferSize; j++) begin
            mem[alignedAddr + j] <= writeData[8*j+7 -: 8]; 
         end
      end
   end
endmodule

module datamem_testbench ();
   logic [63:0] readData,
   logic [63:0] addr,
   logic [63:0] writeData,
   logic        writeEnable,
   logic        readEnable,
   logic  [3:0] xferSize,
   logic        clk

   datamem dut (
      .readData,
      .addr,
      .writeData,
      .writeEnable,
      .readEnable,
      .xferSize,
      .clk
   );

   parameter CLK_PER = 5000;
   initial begin // Set up the clock
      clk <= 0;
      forever #(CLK_PER / 2) clk <= ~clk;
   end

   // Keep copy of what we've done so far.
   logic [7:0] testData [`DATA_MEM_SIZE - 1 : 0];
   
   integer i, j, t;
   logic [63:0] randAddr, randData;
   logic  [3:0] randSize;
   logic        rand_we;
   
   initial begin
      address     <= '0;
      readEnable  <= '0;
      writeEnable <= '0;
      writeData   <= 'x;
      xferSize    <= 4'd8; @(posedge clk);
      for(i = 0; i < 1024*`DATA_MEM_SIZE; i++) begin
         // Set up transfer in rand*, then send to outputs.
         rand_we = $random();
         randData = $random();
         randSize = $random() & 2'b11;
         randSize = 4'b0001 << randSize; // 1, 2, 4, or 8
         randAddr = $random() & (`DATA_MEM_SIZE-1);
         randAddr = (randAddr / randSize) * randSize; // Block aligned

         writeEnable <= rand_we;
         readEnable  <= ~rand_we;
         xferSize    <= randSize;
         address     <= randAddr;
         writeData   <= randData;

         @(posedge clk); // Do the xfer.

         if (rand_we) begin // Track Writes
            for(j = 0; j < randSize; j++) begin
               testData[randAddr+j] = randData[8*j+7 -: 8];
            end
         end else begin // Verify reads.
            for (j = 0; j < randSize; j++) begin
               // === will return true when comparing X's.
               assert(testData[randAddr+j] === read_data[8*j+7 -: 8]);
            end
         end
      end
      $stop;
   end
endmodule
