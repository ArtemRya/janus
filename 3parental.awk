BEGIN {
	errfile = "errors.3.log"
	print "" > errfile
	YEAR_PARENTAL_NAME = 1965
}


$2 != $3 {
	print "ERROR ("NR") "$1": names different '"$2"' != '"$3"'" > errfile
}


{
	spacepos = index ($2, " ")
	if (spacepos == 0) {
	    lastname = $2
	     firstname = ""
	     parentname = ""
     } else {
        lastname = substr ($2, 1, spacepos - 1)
        name = substr ($2, spacepos + 1)
        spacepos = index (name, " ")
        if (spacepos >0 && $6 > YEAR_PARENTAL_NAME) { # удалить отчество надо
            name = substr (name, 1, spacepos - 1)
        }
    }
    print $5 "|" lastname "|" name "|" $8 "|" $7 "|" $4 "|" $1
}
