

# QUARTUS_PATH = c:/altera/15.1/quartus

# ------------------------------------------

PROJECT       = owm_test
TOP_ENTITY    = owm_test_top
DEVICE_FAMILY = "Cyclone IV E"
DEVICE_PART   = EP4CE22F17C6
IO_ASSIGNMENTS_TCL = ../scripts/de0nano_pins.tcl

SERIAL_FLASH_DEVICE        = EPCS64
SERIAL_FLASH_LOADER_DEVICE = $(DEVICE_PART)

# ------------------------------------------

QSYS_OUT_DIR = .qsys_out
QSYS_LIB_PATH = ../avalon-1wire-master/rtl

vpath %.qsys ../rtl
QSYS_SRC  = owm_sys.qsys

vpath %.sv ../rtl
HDL_SRC += owm_test_top.sv

vpath %.qip ../rtl
QIP_SRC += pll.qip

vpath %.stp .

vpath %.sdc ../scripts
SCRIPTS_SRC = owm_test.sdc

# ------------------------------------------

include ../altera-makefile/quartus/quartus.mk
