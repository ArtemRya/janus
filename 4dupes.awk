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
    cur = $1 s $2 s $3  # ДР , фамилия , имя отчество
    gsub(" ","",$4) # EMail - get rid of spaces

    if (cur == previous) {
        if (previousEMail == "") {
            previousEMail = getEMail($4)
            if (previousEMail == "") {
                print NR " -----EXCLUDE дупликат исключён (no email): " $0
            } else {
                print NR " -----EMAIL ADDED in ABOVE row: " $0 " (" previousEMail ")"
            }
        } else {
            print NR " -----EXCLUDE дупликат исключён (email present): " $0
        }
    } else {
        printPrevious()
        previous = cur
        previousEMail = getEMail($4)
        if (previousEMail != "") { # email fine
            print NR " ++E-MAIL: " $0
            # print $1 s $2 s $3 s $4 s $6 > emailFile
        } else {   # email bad => use phone
            if ($4 != "") {
                print "ERROR (" NR ") " $7 " bad email format " $4 > logfile
                print NR " ! bad email format => use phone: " $0
            } else {
                print NR "+Phone: " $0
            }

            # before = $5
            # gsub(/[^d,]/, "", $5)
            # TODO split

            gsub(",", ";", $5)

            # print NR " +phone: " $0
            # print $1 s $2 s $3 s $5 s $6 > phonesFile
            previousPhone = $5
        }
    }
}


END {
    printPrevious()
}



function printPrevious() {
    if ( previous != "" ) {
        if (previousEMail != "") {
            print previous s previousEMail s $6 > emailFile
        } else {
            print previous s previousPhone s $6 > phonesFile
        }
    }
}


function getEMail(roughEMail) {
    if (roughEMail ~ /[^@]+@[^@\]+\.[\@]+/) { # email fine

        before = roughEMail
        for (replacement in emailChange) {
            # print NR "-DEBUG repl " emailChange[replacement] " =>" replacement " in " $4
            gsub(emailChange[replacement], replacement, roughEMail)
            # print NR "-DEBUG result " $4
        }
        if (before != roughEMail) {
            print NR " @ email changed from " before " to " roughEMail
        }
        return roughEMail
     } else {
        return ""
     }
}
