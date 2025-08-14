BEGIN {
    print "HI"
    FS = ","
    OFS = ","

    # Read control data from CSV file
    while ((getline < "control_data.csv") > 0) {
        split($0, arr, ",")
        key = arr[1] "," arr[2] "," arr[3]
        control[key] = arr[4]
        days[key] = arr[5]
    }
    close("control_data.csv")
}

function match_day(key, dow) {
    return (key in days) && index(days[key], dow)
}

{
    c = split($0, LINE, ",")
    ret = ""
    for (i = 2; i <= c; i++) {
        dow = (i - 1) % 7
        for (j = 1; j <= 2; j++) {
            key = $1 "," LINE[i] "," j
            if (match_day(key, dow)) {
                ret = ret " " control[key]
            }
        }
    }
    print ret
}
