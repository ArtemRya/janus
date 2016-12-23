BEGIN {
#    prevDate = ""
    prevLastName = ""
    previous = ""
    logfile = "janus.log"
    emailfile = "rez4.emails.csv"
    s = "|"  # TODO use ,
}

{
    # cur = $0 /     gsub($7,"",cur)

    cur = $1 s $2 s $3

    if (cur == previous) {
        print NR " -----EXCLUDE дупликат исключён: " $0
    } else {
        gsub(" ","",$4)
        if ($4 ~ /[^@]+@[^@\]+\.[\@]+/) { # email fine
            print $1 s $2 " " $3 s $4 s $6 > emailfile
            previous = cur
            print NR " ++E-MAIL: " $0
        } else {   # email bad => use phone
            if ($4 != "") {
                print "ERROR (" NR ") " $7 " bad email format " $7 > logfile
                print NR " ! bad email format => use phone: " $0
            }
            print NR "+phone - !!! TODO !!"
        }
    }
}
