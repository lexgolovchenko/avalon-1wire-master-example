
proc IOWR32 {master base offset wrdata} {
    set addr [expr $base + $offset * 4]
    master_write_32 $master $addr $wrdata
}

proc IORD32 {master base offset {size 1}} {
    set addr [expr $base + $offset * 4]
    return [master_read_32 $master $addr $size]
}
