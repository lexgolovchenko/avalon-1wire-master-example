
puts "-----------------------------------------"
puts "-- Configure BSP...start                 "

set_setting hal.enable_exit             0
set_setting hal.enable_clean_exit       0
set_setting hal.enable_c_plus_plus      0
set_setting hal.enable_sopc_sysid_check 0

set_setting hal.enable_small_c_library         1
set_setting hal.enable_reduced_device_drivers  1

set_setting hal.stdin  ""
set_setting hal.stdout jtag_uart_0
set_setting hal.stderr ""

# set_driver none jtag_uart_0

puts "-- Configure BSP...done                  "
puts "-----------------------------------------"
