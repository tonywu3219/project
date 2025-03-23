set clock_cycle 50.0 
set io_delay 0.2 

set clock_port clk

create_clock -name clk -period $clock_cycle [get_ports $clock_port]

set_input_delay  $io_delay -clock $clock_port [all_inputs] 
set_output_delay $io_delay -clock $clock_port [all_outputs]

#set_false_path -from [get_ports reset]

#set_multicycle_path -setup 2 -from [get_pins mac_array_instance/*col_idx*/*key_q_reg*/*] -to [get_pins ofifo_inst/*col_idx*/*q*_reg*/*]
#set_multicycle_path -hold 1 -from [get_pins mac_array_instance/*col_idx*/*key_q_reg*/*] -to [get_pins ofifo_inst/*col_idx*/*q*_reg*/*]

#set_multicycle_path -setup 2 -from [get_pins mac_array_instance/*col_idx*/*query_q_reg*/*] -to [get_pins ofifo_inst/*col_idx*/*q*_reg*/*]
#set_multicycle_path -hold 1 -from [get_pins mac_array_instance/*col_idx*/*query_q_reg*/*] -to [get_pins ofifo_inst/*col_idx*/*q*_reg*/*]

#set_multicycle_path -setup 3 -from [get_pins mac_array_instance/*col_idx*/mac_8in_instance/*a*] -to [get_pins mac_array_instance/*col_idx*/mac_8in_instance/*out*]
#set_multicycle_path -hold 2 -from [get_pins mac_array_instance/*col_idx*/mac_8in_instance/*b*] -to [get_pins mac_array_instance/*col_idx*/mac_8in_instance/*out*]
