#!/bin/bash

#given a directory of bed files
#removes first **2** lines from a bunch of files and puts them in the nh directory.

mkdir $1/nh
for X in $1/*.bed
do
	F=`basename $X`
        tail +3 $X > $1/nh/$F
	echo "stripped header version in $1/nh/$F";
done

