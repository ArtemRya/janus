BEGIN {
#    prevDate = ""
    prevLastName = ""
    previous = ""
    logfile = "janus.log"
    emailfile = "rez4.emails.csv"
    s = "|"  # TODO use ,

    emailChange[".ru"] = "\.r$"
    emailChange[".com"] = "\.co?$"

}

{
    # cur = $0 /     gsub($7,"",cur)

    cur = $1 s $2 s $3

    if (cur == previous) {
        print NR " -----EXCLUDE дупликат исключён: " $0
    } else {
        gsub(" ","",$4)
        if ($4 ~ /[^@]+@[^@\]+\.[\@]+/) { # email fine
            previous = cur

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
            print $1 s $2 " " $3 s $4 s $6 > emailfile
        } else {   # email bad => use phone
            if ($4 != "") {
                print "ERROR (" NR ") " $7 " bad email format " $7 > logfile
                print NR " ! bad email format => use phone: " $0
            }
            print NR "+phone - !!! TODO !!"
        }
    }
}
