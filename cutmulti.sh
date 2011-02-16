#!/bin/bash

#given a file with format gene tab col1 tab col2... gives multiple files each with first column and one of the following columns.


COLS=`sed -n 2p $1 | wc -w`

for num in `seq 2 $COLS`; 
do
	num2=$(($num-1))
	cut -f1,$num $1 > $1.$num2
done

