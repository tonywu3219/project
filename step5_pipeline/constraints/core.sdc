set clock_cycle 1.0 
set io_delay 0.2 

set clock_port clk

create_clock -name clk -period $clock_cycle [get_ports $clock_port]

set_input_delay  $io_delay -clock $clock_port [all_inputs] 
set_output_delay $io_delay -clock $clock_port [all_outputs]

set_false_path -from [get_ports reset]
set_multicycle_path -setup 4 -from sfp_instance/fifo_inst_int/q* -to sfp_instance/sfp_out_sign*
set_multicycle_path -setup 4 -from sfp_instance/fifo_inst_int/rd_ptr* -to sfp_instance/sfp_out_sign*
set_multicycle_path -setup 4 -from sum_in* -to sfp_instance/sfp_out_sign*
set_multicycle_path -setup 4 -from sfp_instance/sfp_in* -to sfp_instance/sfp_out_sign*
set_multicycle_path -hold 3 -from sfp_instance/fifo_inst_int/q* -to sfp_instance/sfp_out_sign*
set_multicycle_path -hold 3 -from sfp_instance/fifo_inst_int/rd_ptr* -to sfp_instance/sfp_out_sign*
set_multicycle_path -hold 3 -from sum_in* -to sfp_instance/sfp_out_sign*
set_multicycle_path -hold 3 -from sfp_instance/sfp_in* -to sfp_instance/sfp_out_sign*
