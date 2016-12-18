#!/bin/bash
echo $1
# cat $1
cut $1 -d "|" -f 1,2,3,4,5,7,8,9 > rez1.fields.csv
# cat rez1.fields.csv
awk -F "|" -f 1be.awk rez1.fields.csv > rez2.spaces.hdr.csv
awk -F "|" -f 3parental.awk rez2.spaces.hdr.csv | sort > rez3.parental.csv
