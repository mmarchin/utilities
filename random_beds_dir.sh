#!/bin/bash

#given a list of directories of bed files, create one random bed file for each..

for dir in $@
{
	mkdir $dir/random
	for X in $dir/*.bed
	do
		F=`basename $X | sed 's/$/_random/g'`
		perl ~/utilities/random_bed.pl ~/utilities/chrom_lengths/fly_chrom_lengths_jbz3.txt $X > $dir/random/$F
		#perl ~/utilities/random_bed.pl ~/utilities/chrom_lengths/yeast_chrom.txt $X > $dir/random/$F
		echo "random bed in $dir/random/$F";
	done
}
