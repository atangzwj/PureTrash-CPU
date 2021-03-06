# Create work library
vlib work

# Compile Verilog
#    All Verilog files that are part of this design should have
#    their own "vlog" line below.
vlog "../registers/regfile.sv"
vlog "../registers/regfile_testbench.sv"
vlog "../registers/register.sv"
vlog "../registers/d_ff.sv"

vlog "../decoders/decoder2_4.sv"
vlog "../decoders/decoder3_8.sv"
vlog "../decoders/decoder5_32.sv"

vlog "../muxes/mux2_1.sv"
vlog "../muxes/mux4_1.sv"
vlog "../muxes/mux8_1.sv"
vlog "../muxes/mux16_1.sv"
vlog "../muxes/mux32_1.sv"
vlog "../muxes/busMux2_1.sv"
vlog "../muxes/busMux4_1.sv"
vlog "../muxes/busMux8_1.sv"
vlog "../muxes/busMux16_1.sv"
vlog "../muxes/busMux32_1.sv"

vlog "../math/nor64.sv"

vlog "../math/adders/halfAdder.sv"
vlog "../math/adders/fullAdder.sv"
vlog "../math/adders/spg.sv"
vlog "../math/adders/lcu.sv"
vlog "../math/adders/cla4.sv"
vlog "../math/adders/cla16.sv"
vlog "../math/adders/cla64.sv"

vlog "../math/alu/alu_testbench.sv"
vlog "../math/alu/alu1.sv"
vlog "../math/alu/alu4.sv"
vlog "../math/alu/alu16.sv"
vlog "../math/alu/alu64.sv"
vlog "../math/alu/alu.sv"

vlog "../memory/instructmem.sv"
vlog "../memory/datamem.sv"

# Call vsim to invoke simulator
#    Make sure the last item on the line is the name of the
#    testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work instructmem_testbench

# Source the wave do file
#    This should be the file that sets up the signal window for
#    the module you are testing.
#do ./wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
