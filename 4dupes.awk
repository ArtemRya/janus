BEGIN {
    prevLastName = ""
    previous = ""
    logfile = "janus.log"
    emailFile = "!!emails.csv"
    phonesFile = "!!phones.csv"
    s = ","

    emailChange[".ru"] = "\.r$"
    emailChange[".com"] = "\.co?$"
}

{
    cur = $1 s $2 s $3

    if (cur == previous) {
        print NR " -----EXCLUDE дупликат исключён: " $0
    } else {
        previous = cur
        gsub(" ","",$4)
        if ($4 ~ /[^@]+@[^@\]+\.[\@]+/) { # email fine

            before = $4
            for (replacement in emailChange) {
                # print NR "-DEBUG repl " emailChange[replacement] " =>" replacement " in " $4
                gsub(emailChange[replacement], replacement, $4)
                # print NR "-DEBUG result " $4
            }
            if (before != $4) {
                print NR " @ email changed from " before " to "
            }

            print NR " ++E-MAIL: " $0
            print $1 s $2 s $3 s $4 s $6 > emailFile
        } else {   # email bad => use phone
            if ($4 != "") {
                print "ERROR (" NR ") " $7 " bad email format " $4 > logfile
                print NR " ! bad email format => use phone: " $0
            }

            # before = $5
            # gsub(/[^d,]/, "", $5)
            # TODO split

            gsub(",", ";", $5)

            print NR " +phone: " $0
            print $1 s $2 s $3 s $5 s $6 > phonesFile
        }
    }
}
