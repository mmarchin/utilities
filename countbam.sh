#!/bin/bash

for X in *.bam
	do
		B=`basename $X .bam`;
		count=`samtools idxstats $X | cut -f 3 | awk '{s+=$1} END {print s}'`
		echo "$B	$count";
	done
