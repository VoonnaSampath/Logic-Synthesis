create_clock -period 0.444 [get_ports clk]
set_clock_uncertainty -setup 0.02664 [get_clocks clk]
set_clock_uncertainty -hold 0.02664 [get_clocks clk]
set_clock_latency -max 0.05 [get_clock clk]
set_clock_latency -source -max 0 [get_clock clk]

set_clock_transition -max 0.02664 [get_clocks clk]
set_input_delay -max 0.1998 -clock clk [all_inputs]
remove_input_delay [get_ports clk]
set_output_delay -max 0.1998 -clock clk [all_outputs]

set_max_transition 0.02664 [current_design]
set_max_capacitance 0.02664 [current_design]
set_max_fanout 6 [current_design]
