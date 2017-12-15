
# -----------------------------------------------------------------
# 1-wire ROM command
# -----------------------------------------------------------------
#

set OWM_SEARCH_ROM    0xf0
set OWM_READ_ROM      0x33
set OWM_MATCH_ROM     0x55
set OWM_SKIP_ROM      0xcc
set OWM_ALARM_SEARCH  0xec

# -----------------------------------------------------------------
# Read 1-wire slave ID
#
# N.B. For correct execution of READ_ROM command
# only one slave device allowed
# -----------------------------------------------------------------
#

proc owm_read_id {base} {
    if {![owm_reset $base]} {
        return {}
    }

    owm_write_byte $base $::OWM_READ_ROM

    return [owm_read_data $base 8]
}

# -----------------------------------------------------------------
# Check CRC8 of 1-wire slave ID
# Return 1 if CRC8 correct
# -----------------------------------------------------------------
#
proc owm_check_id_crc {id} {
    set id_crc [lindex $id 7]
    set calc_crc [owm_crc8 [lrange $id 0 [expr [llength $id] - 2]]]

    if {$id_crc == $calc_crc} {
        return 1
    } else {
        return 0
    }
}

# -----------------------------------------------------------------
# 1-wire search algorithm
#
# N.B. 'ids' is array type!
# -----------------------------------------------------------------
#

proc owm_search {base ids_arr} {
    upvar $ids_arr ids

    set last_device_flag 0
    set last_discrepancy 0
    set search_direction 0
    set cur_dev_num 0

    # List of bits
    set last_id {}

    while {1} {
        if {![owm_reset $base]} {
            return -1
        }

        if {$last_device_flag} {
            break
        }

        owm_write_byte $base $::OWM_SEARCH_ROM

        set id_bit_num 1
        set last_zero 0
        set cur_id {}
        while {1} {
            set id_bit [owm_read_bit $base]
            set cmp_id_bit [owm_read_bit $base]

            if {[expr $id_bit && $cmp_id_bit]} {
                return -2
            } elseif {[expr !$id_bit && !$cmp_id_bit]} {

                if {$id_bit_num == $last_discrepancy} {
                    set search_direction 1
                } elseif {$id_bit_num > $last_discrepancy} {
                    set search_direction 0
                } else {
                    set search_direction [lindex $last_id [expr $id_bit_num - 1]]
                }

                if {$search_direction == 0} {
                    set last_zero $id_bit_num
                }

            } else {
                set search_direction $id_bit
            }

            lappend cur_id $search_direction

            owm_write_bit $base $search_direction

            incr id_bit_num
            if {$id_bit_num > 64} {
                break
            }
        }

        set last_discrepancy $last_zero
        if {$last_discrepancy == 0} {
            set last_device_flag 1
        }

        set id [__owm_bit_list_to_id $cur_id]
        if {![owm_check_id_crc $id]} {
            return -3
        }

        set ids($cur_dev_num) $id

        set last_id $cur_id
        incr cur_dev_num
    }

    return $cur_dev_num
}

proc __owm_bit_list_to_id {bit_list} {
    set id {}
    for {set i 0} {$i < 8} {incr i} {
        set byte 0
        for {set j 0} {$j < 8} {incr j} {
            set bit [lindex $bit_list [expr 8 * $i + $j]]
            set byte [expr $byte | ($bit << $j)]
        }
        lappend id $byte
    }
    return $id
}
