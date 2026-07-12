read_verilog ../rtl/comb_multiplier.v

current_design comb_multiplier
link
check_design

source scripts/constraints.tcl

compile_ultra

redirect -file reports/comb_area.rpt   { report_area }
redirect -file reports/comb_timing.rpt { report_timing -delay max -max_paths 10 }
redirect -file reports/comb_power.rpt  { report_power }
redirect -file reports/comb_clock.rpt  { report_clock }
redirect -file reports/comb_qor.rpt { report_qor }

quit
