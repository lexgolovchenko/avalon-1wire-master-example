
# -----------------------------------------------------
# Load libraries
# -----------------------------------------------------
#
set cur_script_path [file dirname [info script]]

source [file join $cur_script_path avalon_io.tcl]
source [file join $cur_script_path owm_io.tcl]
source [file join $cur_script_path owm_crc.tcl]
source [file join $cur_script_path owm_search.tcl]
source [file join $cur_script_path ds18b20.tcl]

# -----------------------------------------------------
# Get path of jtag-to-avalon-master
# -----------------------------------------------------
#
set mpath ""
foreach m [get_service_paths master] {
    if {[string match "*master" $m]} {
        set mpath $m
    }
}

# -----------------------------------------------------
# Claim master service
# -----------------------------------------------------
#
if {![info exists master_service]} {
    set master_service [claim_service master $mpath ""]
    puts "Service $master_service is opened!"
} else {
    puts "Service $master_service alredy opened!"
}

proc close_all {} {
    close_service master $::master_service
    unset ::master_service
}

# -----------------------------------------------------
# Find all 1-wire slave
# -----------------------------------------------------
#

set OWM_BASE 0x4000

set OWM_CLK_PRCL 49
set OWM_TIMINGS {480 480 100 60 10 2 60 10 13 2}

owm_init $OWM_BASE $OWM_CLK_PRCL $OWM_TIMINGS

set array ids

set slv_num [owm_search $OWM_BASE ids]

if {$slv_num > 0} {
    puts "Find $slv_num devices:"
    foreach i [array names ids] {
        puts $ids($i)
    }
} else {
    puts "Slaves not found!"
}
