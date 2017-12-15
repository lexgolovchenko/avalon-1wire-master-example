
# -----------------------------------------------------------------
# 1-wire master registers
# -----------------------------------------------------------------
#
set OWM_CLK_PRECL_REG          0

set OWM_T_RESET_L_REG          1
set OWM_T_RESET_H_REG          2
set OWM_T_RESET_PD_REG         3
set OWM_T_WRITE_SLOT_REG       4
set OWM_T_WRITE_L_REG          5
set OWM_T_WRITE_REC_REG        6
set OWM_T_READ_SLOT_REG        7
set OWM_T_READ_L_REG           8
set OWM_T_READ_READ_REG        9
set OWM_T_READ_REC_REG         10

set OWM_CONTROL_REG            11
set OWM_CONTROL_RESET_REQ_MSK  1
set OWM_CONTROL_RESET_REQ_OFST 0
set OWM_CONTROL_WRITE_REQ_MSK  2
set OWM_CONTROL_WRITE_REQ_OFST 1
set OWM_CONTROL_WRITE_VAL_MSK  4
set OWM_CONTROL_WRITE_VAL_OFST 2
set OWM_CONTROL_READ_REQ_MSK   8
set OWM_CONTROL_READ_REQ_OFST  3

set OWM_STATUS_REG             12
set OWM_STATUS_PRESENCE_MSK    1
set OWM_STATUS_PRESENCE_OFST   0
set OWM_STATUS_READ_VAL_MSK    2
set OWM_STATUS_READ_VAL_OFST   1
set OWM_STATUS_IDLE_MSK        4
set OWM_STATUS_IDLE_OFST       2
set OWM_STATUS_READY_MSK       8
set OWM_STATUS_READY_OFST      3

set OWM_IE_REG                 13
set OWM_IE_IE_MSK              1
set OWM_IE_IE_OFST             0

set OWM_OW_ADDR_REG            14

# -----------------------------------------------------------------
# 1-wire master initialization
# -----------------------------------------------------------------
#
proc owm_init {base clk_prcl timings} {
    # Set clock prescaler
    IOWR32 $::master_service $base $::OWM_CLK_PRECL_REG $clk_prcl

    # Set timings
    IOWR32 $::master_service $base $::OWM_T_RESET_L_REG    [lindex $timings 0]
    IOWR32 $::master_service $base $::OWM_T_RESET_H_REG    [lindex $timings 1]
    IOWR32 $::master_service $base $::OWM_T_RESET_PD_REG   [lindex $timings 2]
    IOWR32 $::master_service $base $::OWM_T_WRITE_SLOT_REG [lindex $timings 3]
    IOWR32 $::master_service $base $::OWM_T_WRITE_L_REG    [lindex $timings 4]
    IOWR32 $::master_service $base $::OWM_T_WRITE_REC_REG  [lindex $timings 5]
    IOWR32 $::master_service $base $::OWM_T_READ_SLOT_REG  [lindex $timings 6]
    IOWR32 $::master_service $base $::OWM_T_READ_L_REG     [lindex $timings 7]
    IOWR32 $::master_service $base $::OWM_T_READ_READ_REG  [lindex $timings 8]
    IOWR32 $::master_service $base $::OWM_T_READ_REC_REG   [lindex $timings 9]

    # Disable interrupt
    IOWR32 $::master_service $base $::OWM_IE_REG 0

    # Read status, clear ready bit
    IORD32 $::master_service $base $::OWM_STATUS_REG

    # Default 1-wire bus
    IOWR32 $::master_service $base $::OWM_OW_ADDR_REG 0
}

# -----------------------------------------------------------------
# Read all memory mapped registers
# -----------------------------------------------------------------
#
proc owm_read_all_regs {base} {
    return [IORD32 $::master_service $base 0 15]
}

# -----------------------------------------------------------------
# Wait when core return to idle state
# Return value of status register
# -----------------------------------------------------------------
#
proc owm_wait_ready {base {ms 1}} {
    while {1} {
        after $ms
        set st [IORD32 $::master_service $base $::OWM_STATUS_REG]
        if {[expr $st & $::OWM_STATUS_IDLE_MSK]} {
            break
        }
    }

    return $st
}

# -----------------------------------------------------------------
# Reset 1-wire bus
# Return 1 if slave presence detected
# -----------------------------------------------------------------
#
proc owm_reset {base} {
    IOWR32 $::master_service \
        $base $::OWM_CONTROL_REG $::OWM_CONTROL_RESET_REQ_MSK

    set st [owm_wait_ready $base]

    return [expr $st & $::OWM_STATUS_PRESENCE_MSK]
}

# -----------------------------------------------------------------
# Write data functions
# -----------------------------------------------------------------
#

proc owm_write_bit {base wrbit} {
    if {$wrbit} {
        IOWR32 $::master_service $base $::OWM_CONTROL_REG \
            [expr $::OWM_CONTROL_WRITE_REQ_MSK | $::OWM_CONTROL_WRITE_VAL_MSK]
    } else {
        IOWR32 $::master_service $base $::OWM_CONTROL_REG \
            $::OWM_CONTROL_WRITE_REQ_MSK
    }

    owm_wait_ready $base
}

proc owm_write_byte {base wr} {
    for {set i 0} {$i < 8} {incr i} {
        owm_write_bit $base [expr $wr & (1 << $i)]
    }
}

proc owm_write_data {base wrdata} {
    foreach wr $wrdata {
        owm_write_byte $base $wr
    }
}

# -----------------------------------------------------------------
# Read data functions
# -----------------------------------------------------------------
#

# Return read bit value
proc owm_read_bit {base} {
    IOWR32 $::master_service $base $::OWM_CONTROL_REG \
        $::OWM_CONTROL_READ_REQ_MSK

    set st [owm_wait_ready $base]

    return [expr ($st & $::OWM_STATUS_READ_VAL_MSK) >> 1]
}

# Return read byte value
proc owm_read_byte {base} {
    set rd 0
    for {set i 0} {$i < 8} {incr i} {
        if {[owm_read_bit $base]} {
            set rd [expr $rd | (1 << $i)]
        }
    }

    return $rd
}

# Return list of bytes
proc owm_read_data {base rdsize} {
    set rdlist {}
    for {set i 0} {$i < $rdsize} {incr i} {
        lappend rdlist [owm_read_byte $base]
    }
    return $rdlist
}
