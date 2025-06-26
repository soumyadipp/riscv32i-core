set_property PACKAGE_PIN V15 [get_ports clkEnable]
set_property IOSTANDARD LVCMOS33 [get_ports clkEnable]

set_property PACKAGE_PIN W16 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# clock

set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

#segments

set_property PACKAGE_PIN U2 [get_ports {anode_activate[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_activate[0]}]

set_property PACKAGE_PIN U4 [get_ports {anode_activate[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_activate[1]}]

set_property PACKAGE_PIN V4 [get_ports {anode_activate[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_activate[2]}]

set_property PACKAGE_PIN W4 [get_ports {anode_activate[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_activate[3]}]

set_property PACKAGE_PIN W7 [get_ports {led_segment[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_segment[6]}]

set_property PACKAGE_PIN W6 [get_ports {led_segment[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_segment[5]}]

set_property PACKAGE_PIN U8 [get_ports {led_segment[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_segment[4]}]

set_property PACKAGE_PIN V8 [get_ports {led_segment[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_segment[3]}]

set_property PACKAGE_PIN U5 [get_ports {led_segment[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_segment[2]}]

set_property PACKAGE_PIN V5 [get_ports {led_segment[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_segment[1]}]

set_property PACKAGE_PIN U7 [get_ports {led_segment[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_segment[0]}]

set_property PACKAGE_PIN V7 [get_ports dp]
set_property IOSTANDARD LVCMOS33 [get_ports dp]

# leds

set_property PACKAGE_PIN U19 [get_ports slow_clk]
set_property IOSTANDARD LVCMOS33 [get_ports slow_clk]


set_property PACKAGE_PIN U15 [get_ports {scroll}]
set_property IOSTANDARD LVCMOS33 [get_ports {scroll}]

set_property PACKAGE_PIN P3 [get_ports {op}]
set_property IOSTANDARD LVCMOS33 [get_ports {op}]



set_property PACKAGE_PIN U18 [get_ports {BTNC}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTNC}]
#Bank = 14, Pin name = ,Sch name = BTNU
set_property PACKAGE_PIN T18 [get_ports {BTNU}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTNU}]
#Bank = 14, Pin name = ,Sch name = BTNL
set_property PACKAGE_PIN W19 [get_ports {BTNL}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTNL}]
#Bank = 14, Pin name = ,Sch name = BTNR
set_property PACKAGE_PIN T17 [get_ports {BTNR}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTNR}]
#Bank = 14, Pin name =,Sch name = BTND
set_property PACKAGE_PIN U17 [get_ports {BTND}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTND}]
