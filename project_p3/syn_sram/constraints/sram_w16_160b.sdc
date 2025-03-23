set clock_cycle 50.0 
set io_delay 0.2 

set clock_port CLK

create_clock -name CLK -period $clock_cycle [get_ports $clock_port]

set_input_delay  $io_delay -clock $clock_port [all_inputs] 
set_output_delay $io_delay -clock $clock_port [all_outputs]

#set_multicycle_path -setup 2 -from [get_ports *A*] -to [get_pins *memory*/*]
#set_multicycle_path -hold 1 -from [get_ports *A*] -to [get_pins *memory*/*]

#set_multicycle_path -setup 2 -from [get_nets *D*] -to [get_pins *memory*/*]
#set_multicycle_path -hold 1 -from [get_nets *D*] -to [get_pins *memory*/*]

#set_multicycle_path -setup 2 -from [get_nets *memory*/*] -to [get_pins *Q_reg*/*]
#set_multicycle_path -hold 1 -from [get_nets *memory*/*] -to [get_pins *Q_reg*/*]