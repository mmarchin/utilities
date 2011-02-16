#!/bin/bash

#given a list of directories of gzipped wig chromosomes (like macs gives), create big wigs.

for dir in $@
{
	mkdir $dir/bigwig
	mkdir $dir/nh
	gunzip $dir/*.gz
	for X in $dir/*.wig
	do
		F=`basename $X`
		tail +2 $X > $dir/nh/$F;
	done
	cat $dir/nh/* > $dir/cat_nh
	gzip $dir/cat_nh
	./fetchChromSizes.sh dm3 > dm3.chrom.sizes
	echo "./wigToBigWig $dir/cat_nh.gz dm3.chrom.sizes $dir/bigwig/my.bw"
	echo "track type=bigWig name="My Big Wig" description="" dataUrl=http://research.stowers-institute.org/microarray/track_files/Zeitlinger/julia_zeitlinger/jbz3/my.bw"
}

#abandoned
