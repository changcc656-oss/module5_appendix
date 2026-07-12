set_max_area 0

create_clock -name clk -period 10 [get_ports clk]
set_clock_transition 0.5 [get_clocks clk]

set_input_delay 1 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 1 -clock clk [all_outputs]

set_input_transition 0.8 [remove_from_collection [all_inputs] [get_ports clk]]
set_load 0.001 [all_outputs]
