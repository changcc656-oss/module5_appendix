read_verilog ../rtl/adder.v
read_verilog ../rtl/seq_multiplier.v

current_design seq_multiplier
link
check_design

source scripts/constraints.tcl

compile_ultra

redirect -file reports/seq_area.rpt   { report_area }
redirect -file reports/seq_timing.rpt { report_timing -delay max -max_paths 10 }
redirect -file reports/seq_power.rpt  { report_power }

quit
