BEGIN {
    prevLastName = ""
    previous = ""
    logfile = "janus.log"
    emailFile = "!emails.csv"
    phonesFile = "!phones.csv"
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
            print $1 s $2 " " $3 s $4 s $6 > emailFile
        } else {   # email bad => use phone
            if ($4 != "") {
                print "ERROR (" NR ") " $7 " bad email format " $4 > logfile
                print NR " ! bad email format => use phone: " $0
            }

            before = $5
            # print NR "+phone - !!! TODO !!"
            commaPos = index ($5, ",")
            if (commaPos > 0) {
                if (commaPos < 8) {
                    print "ERROR (" NR ") " $7 " телефон имеет запятую как-то слишком рано" > logfile
                    print NR " ! телефон имеет запятую как-то слишком рано: " $0
                } else {
                    $5 = substr($5, 1, commaPos - 1)
                }
            }


                    print NR " ь телефон изменён с " $5
        }
    }
}
