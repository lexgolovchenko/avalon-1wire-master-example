
create_clock -name clk_50M_i -period 20.000 [get_ports {clk_50M_i}]
derive_clock_uncertainty
derive_pll_clocks

