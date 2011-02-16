#!/bin/bash

for X in *bam
	do
		B=`basename $X .bam`;
		samtools view $X > $B.sam
	done
