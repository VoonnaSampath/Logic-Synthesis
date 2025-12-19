create_clock -period 6 [get_ports clk]
set_clock_uncertainty -setup 1 [get_clocks clk]
set_clock_latency -max 0.3 [get_clock clk]
set_clock_latency -source -max 0.7 [get_clock clk]

set_clock_transition -max 0.4 [get_clocks clk]
set_input_delay -max 1.3 -clock clk [all_inputs]
#remove_input_delay [get_ports clk]
set_output_delay -max 1.3 -clock clk [all_outputs]
