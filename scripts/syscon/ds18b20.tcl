
# -----------------------------------------------------------------
# ds18b20 commands
# -----------------------------------------------------------------
#

set DS18x20_CONVERT_T           0x44
set DS18x20_WRITE_SCRATCHPAD    0x4e
set DS18x20_READ_SCRATCHPAD     0xbe

set DS18B20_FAMILY_ID           0x28
set DS18S20_FAMILY_ID           0x10

# -----------------------------------------------------------------
# Configure of ds18b20
# -----------------------------------------------------------------
# Configuration data:
#
# 0, 1 - temperature threshold for alarm search
# 2 - config data, [4:0] = 0x1f, [6:5] = measurements resolution:
#      0 - 9-bit   (0x1f)
#      1 - 10-bit  (0x3f)
#      2 - 11-bit  (0x5f)
#      3 - 12-bit  (0x7f)
#

proc ds18b20_init {base id cfgdata} {
    if {![owm_reset $base]} {
        return 0
    }

    if {[llength $id] == 8} {
        owm_write_byte $base $::OWM_MATCH_ROM
        owm_write_data $base $id
    } else {
        owm_write_byte $base $::OWM_SKIP_ROM
    }

    owm_write_byte $base $::DS18x20_WRITE_SCRATCHPAD
    owm_write_data $base $cfgdata

    return 1
}

# -----------------------------------------------------------------
# Start temperature meassure
# -----------------------------------------------------------------
#
# If id not specified, command will send to all sensors
#

proc ds18x20_convert_t {base id} \
{
    if {![owm_reset $base]} {
        return 0
    }

    if {[llength $id] == 8} {
        owm_write_byte $base $::OWM_MATCH_ROM
        owm_write_data $base $id
    } else {
        owm_write_byte $base $::OWM_SKIP_ROM
    }

    owm_write_byte $base $::DS18x20_CONVERT_T

    # Wait while any slaves hold the bus
    while {1} {
        after 1
        if {[owm_read_bit $base]} {
            break
        }
    }

    return 1
}

# -----------------------------------------------------------------
# Read internal memory
# -----------------------------------------------------------------
#
# Return 9 bytes of data
#

proc ds18x20_read_scratchpad {base id} {
    if {![owm_reset $base]} {
        return {}
    }

    if {[llength $id] == 8} {
        owm_write_byte $base $::OWM_MATCH_ROM
        owm_write_data $base $id
    } else {
        owm_write_byte $base $::OWM_SKIP_ROM
    }

    owm_write_byte $base $::DS18x20_READ_SCRATCHPAD

    set data [owm_read_data $base 9]

    return $data
}

# -----------------------------------------------------------------
# Convert read temerature to float
# -----------------------------------------------------------------
# input  - two byte of data (from ds18x20_read_scratchpad result)
#          and precision 0,1,2 or 3 (from ds18b20_init command)
# output - float temerature value
#

proc ds18b20_to_float {rddata} {

}
