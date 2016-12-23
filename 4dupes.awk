BEGIN {
#    prevDate = ""
    prevLastName = ""
    previous = ""
    # logfile = "janus.log"
    emailfile = "rez4.emails.csv"
    s = "|"
}

{
    cur = $0
    gsub($7,"",cur)
    if (cur == previous) {
        print "EXCLUDE дупликат исключён: " $0
    } else {
        gsub(" ","",$4)
        print $1 s $2 " " $3 s $4 > emailfile
        previous = cur
    }
}
