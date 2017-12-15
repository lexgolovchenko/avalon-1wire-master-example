
# -----------------------------------------------------------------
# Default IO assignments
# -----------------------------------------------------------------
#

set UNUSED_IO         "AS INPUT TRI-STATED WITH WEAK PULL-UP"
set DEFAULT_IO_STD    "2.5 V"
set DUAL_PURPOSE_PINS "USE AS REGULAR IO"

# -----------------------------------------------------------------
# Pin assignments
#
# The keys used in the assignments list are an abbreviation of
# the Quartus setting name. The abbreviations supported are;
#
#   DRIVE   = drive current
#   HOLD    = bus hold (ON/OFF)
#   IOSTD   = I/O standard
#   PIN     = pin number/name
#   PULLUP  = weak pull-up (ON/OFF)
#   SLEW    = slew rate (a number between 0 and 3)
#   TERMIN  = input termination (string value)
#   TERMOUT = output termination (string value)
#
# -----------------------------------------------------------------
#

set PIN(clk_50M_i) {PIN = R8  , IOSTD = "3.3-V LVCMOS"}
set PIN(ow_io)     {PIN = B12 , IOSTD = "3.3-V LVCMOS"}


set PIN(led_o[0]) {PIN = A15 , IOSTD = "3.3-V LVCMOS"}
set PIN(led_o[1]) {PIN = A13 , IOSTD = "3.3-V LVCMOS"}
set PIN(led_o[2]) {PIN = B13 , IOSTD = "3.3-V LVCMOS"}
set PIN(led_o[3]) {PIN = A11 , IOSTD = "3.3-V LVCMOS"}
set PIN(led_o[4]) {PIN = D1  , IOSTD = "3.3-V LVCMOS"}
set PIN(led_o[5]) {PIN = F3  , IOSTD = "3.3-V LVCMOS"}
set PIN(led_o[6]) {PIN = B1  , IOSTD = "3.3-V LVCMOS"}
set PIN(led_o[7]) {PIN = L3  , IOSTD = "3.3-V LVCMOS"}

set PIN(sw_i[0]) {PIN = M1  , IOSTD = "3.3-V LVCMOS"}
set PIN(sw_i[1]) {PIN = T8  , IOSTD = "3.3-V LVCMOS"}
set PIN(sw_i[2]) {PIN = B9  , IOSTD = "3.3-V LVCMOS"}
set PIN(sw_i[3]) {PIN = M15 , IOSTD = "3.3-V LVCMOS"}
