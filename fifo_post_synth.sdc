# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Thu Dec 04 13:43:49 IST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design fifo

create_clock -name "clk" -period 10.0 -waveform {0.0 5.0} [get_ports clk]
set_load -pin_load 0.1 [get_ports {dout[7]}]
set_load -pin_load 0.1 [get_ports {dout[6]}]
set_load -pin_load 0.1 [get_ports {dout[5]}]
set_load -pin_load 0.1 [get_ports {dout[4]}]
set_load -pin_load 0.1 [get_ports {dout[3]}]
set_load -pin_load 0.1 [get_ports {dout[2]}]
set_load -pin_load 0.1 [get_ports {dout[1]}]
set_load -pin_load 0.1 [get_ports {dout[0]}]
set_load -pin_load 0.05 [get_ports empty]
set_load -pin_load 0.05 [get_ports full]
set_false_path -from [get_ports rst_n]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports wr_en]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports rd_en]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {din[7]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {din[6]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {din[5]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {din[4]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {din[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {din[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {din[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {din[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {dout[7]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {dout[6]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {dout[5]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {dout[4]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {dout[3]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {dout[2]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {dout[1]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {dout[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports empty]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports full]
set_drive 0.0 [get_ports clk]
set_drive 1.0 [get_ports wr_en]
set_drive 1.0 [get_ports rd_en]
set_drive 1.0 [get_ports {din[7]}]
set_drive 1.0 [get_ports {din[6]}]
set_drive 1.0 [get_ports {din[5]}]
set_drive 1.0 [get_ports {din[4]}]
set_drive 1.0 [get_ports {din[3]}]
set_drive 1.0 [get_ports {din[2]}]
set_drive 1.0 [get_ports {din[1]}]
set_drive 1.0 [get_ports {din[0]}]
set_wire_load_mode "enclosed"
set_clock_uncertainty -setup 0.2 [get_clocks clk]
set_clock_uncertainty -hold 0.2 [get_clocks clk]
