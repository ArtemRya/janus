BEGIN {
	previous = ""
	logfile = "janus.log"
	print strftime > logfile
	d = ":"
}


NF >= 8 && NR != 1 {
	gsub(/[ \t]+/," ")
	gsub(" \|","|")
	gsub("\| ","|")
	print $0
}

