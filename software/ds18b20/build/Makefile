
SOPCINFO_FILE = ../../../rtl/owm_sys.sopcinfo

BSP_DIR = bsp
APP_DIR = app

BSP_TYPE = hal
BSP_CFG_TCL = bsp_cfg.tcl

ELF = owm_test.elf

INC_DIRS += ../../../avalon-1wire-master/software/HAL/inc
SRC_DIRS += ../../../avalon-1wire-master/software/HAL/src

INC_DIRS += ../inc
SRC_FILES += \
	../src/ds18x20.c    \
	../src/main.c       \
	../src/owm_crc.c    \
	../src/owm_id.c     \
	../src/owm_init.c   \
	../src/owm_search.c

include ../../../altera-makefile/nios/nios2bsp.mk
