// Instruction ROM. Supports reads only, but is initialized with the file
// specified.
// All accesses are 32-bit. Addresses are byte-addresses, and must be
// word-aligned (bottom two bits of the address must be 0).
//
// To change the file that is loaded, edit the filename here:
`define BENCHMARK "./CPU/benchmarks/test00_oneInstr.arm"
//`define BENCHMARK "./CPU/benchmarks/test0a_X31Fwd.arm"
//`define BENCHMARK "./CPU/benchmarks/test0b_Movk.arm"
//`define BENCHMARK "./CPU/benchmarks/test01_AddiB.arm"
//`define BENCHMARK "./CPU/benchmarks/test02_AddsSubs.arm"
//`define BENCHMARK "./CPU/benchmarks/test03_CbzB.arm"
//`define BENCHMARK "./CPU/benchmarks/test04_LdurStur.arm"
//`define BENCHMARK "./CPU/benchmarks/test05_Blt.arm"
//`define BENCHMARK "./CPU/benchmarks/test06_MovkMovz.arm"
//`define BENCHMARK "./CPU/benchmarks/test07_LdurbSturb.arm"
//`define BENCHMARK "./CPU/benchmarks/test10_forwarding.arm"
//`define BENCHMARK "./CPU/benchmarks/test11_Sort.arm"
//`define BENCHMARK "./CPU/benchmarks/test12_ToUpper.arm"
//`define BENCHMARK "./CPU/benchmarks/testSturb_Rad.arm"


`timescale 1ns/10ps

// How many bytes are in our memory?  Must be a power of two
`define INSTRUCT_MEM_SIZE 1024

module instructmem (
   output logic [31:0] instruction,
   input  logic [63:0] address,
   input  logic        clk // Memory is combinational, but used for
);                         // error-checking

   // Print %t's in a nice format
   initial $timeformat(-9, 2, " ns", 10);

   // Make sure size is a power of two and reasonable
   initial begin
      assert((`INSTRUCT_MEM_SIZE & (`INSTRUCT_MEM_SIZE - 1)) == 0);
      assert(`INSTRUCT_MEM_SIZE > 4);
   end

   // Make sure accesses are reasonable
   always_ff @ (posedge clk) begin
      // Address or size could be all X's at startup, so ignore this case
      if (address !== 'x) begin
         // Makes sure address is aligned
         assert(address[1:0] == 0);

         // Make sure address in bounds
         assert(address + 3 < `INSTRUCT_MEM_SIZE);
      end
   end

   // The data storage itself
   logic [31:0] mem [`INSTRUCT_MEM_SIZE/4-1:0];

   // Load the program - change the filename to pick a different program
   initial begin
      $readmemb(`BENCHMARK, mem);
      $display("Running benchmark: ", `BENCHMARK);
   end

   // Handle the reads
   integer i;
   always_comb begin
      if (address + 3 >= `INSTRUCT_MEM_SIZE) instruction = 'x;
      else                                   instruction = mem[address/4];
   end
endmodule

module instructmem_testbench ();
   logic [31:0] instruction;
   logic [63:0] address;
   logic        clk;

   instructmem dut (.instruction, .address, .clk);

   parameter CLK_PER = 5000;
   initial begin // Set up the clock
      clk <= 0;
      forever #(CLK_PER / 2) clk <= ~clk;
   end

   integer i;
   initial begin
      // Read every location, including just past the end of the memory
      for (i=0; i <= `INSTRUCT_MEM_SIZE; i = i + 4) begin
         address <= i; @(posedge clk); 
      end
      $stop;
   end
endmodule
