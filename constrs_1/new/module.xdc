##Cock
set_property PACKAGE_PIN W5 [get_ports clk]							
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

##Reset Button
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

##UART Receiver
set_property PACKAGE_PIN B18 [get_ports rx]						
set_property IOSTANDARD LVCMOS33 [get_ports rx]

##Switches
set_property PACKAGE_PIN V17 [get_ports volume]
set_property IOSTANDARD LVCMOS33 [get_ports volume]
set_property PACKAGE_PIN V16 [get_ports bit_crush]
set_property IOSTANDARD LVCMOS33 [get_ports bit_crush]
set_property PACKAGE_PIN W16 [get_ports pitch_sel]
set_property IOSTANDARD LVCMOS33 [get_ports pitch_sel]

##I2S output ports
set_property -dict { PACKAGE_PIN J1   IOSTANDARD LVCMOS33 } [get_ports bck]
set_property -dict { PACKAGE_PIN L2   IOSTANDARD LVCMOS33 } [get_ports lrck]
set_property -dict { PACKAGE_PIN J2   IOSTANDARD LVCMOS33 } [get_ports sdata]