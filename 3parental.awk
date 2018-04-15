BEGIN {
	errfile = "janus.log"
	YEAR_PARENTAL_NAME = 1965
	
	debugfile = "3parental.debug.log"
	print "" > debugfile
}


$2 != $3 {
	print "ERROR ("NR") "$1": names different '"$2"' != '"$3"'" >> errfile
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
	year = substr ($5, 7)
	if (length(year) == 2) {
		year = "19" year
	}
        if ( length(year)==4 && spacepos>0 && year-YEAR_PARENTAL_NAME>0 ) { # удалить отчество надо
            oldname = name
            name = substr (name, 1, spacepos - 1)
	    print "deleting parental name: " oldname " /" year "\ d " (year - YEAR_PARENTAL_NAME) " >> " name >> debugfile
        } else {
	    print "parental absent or needed or year wrong - " name " /" year >> debugfile
	}
    }
    # birth date | ln       | name  | email | phone | title | order id
    print $5 "|" lastname "|" name "|" $7 "|" $6 "|" $4 "|" $1
}
