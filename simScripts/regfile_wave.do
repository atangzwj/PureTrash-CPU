onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Read -radix hexadecimal /regfile_testbench/readData0
add wave -noupdate -expand -group Read -radix hexadecimal /regfile_testbench/readData1
add wave -noupdate -expand -group Read -radix unsigned /regfile_testbench/readReg0
add wave -noupdate -expand -group Read -radix unsigned /regfile_testbench/readReg1
add wave -noupdate -expand -group Write -radix hexadecimal /regfile_testbench/writeData
add wave -noupdate -expand -group Write -radix unsigned /regfile_testbench/writeReg
add wave -noupdate -expand -group Write /regfile_testbench/regWrEn
add wave -noupdate /regfile_testbench/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {250687500 ps}
