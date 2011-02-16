#!/bin/bash

#given a directory of bed files, create one random bed file for each..

mkdir $1/random
for X in $1/*.bed
do
	F=`basename $X | sed 's/$/_random/g'`
	perl ~/utilities/random_bed.pl ~/utilities/chrom_lengths/yeast_chrom_lengths.txt $X > random/$F
	echo "random bed in $1/random/$F";
done
