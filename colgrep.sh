#modified from internet
#Madelaine Gogol
#6/2013
# colgrep.sh colname file.txt
#
#!/bin/bash
COLS=$(head -1 $2)
for C in $COLS
do
	((i++))
	[ $C = $1 ] && IDX+="$i,"
done
cut -f${IDX%,} $2 
