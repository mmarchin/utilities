#!/bin/sh

#translate chromosomes from ensembl to ucsc -- warning, gets rid of contigs..

#                  remove NT contigs   put chr at beg of numerical chroms     put chr on MT, X, Y.
cat coverage.wig | sed "/^NT_/d" | sed "s/^\([0-9]\+\)\t/chr\1\t/g" | sed "s/^MT/chrM/g" | sed "s/^X/chrX/g" | sed "s/^Y/chrY/g" > coverage_ucsc.wig
cat junctions.bed | sed "/^NT_/d" | sed "s/^\([0-9]\+\)\t/chr\1\t/g" | sed "s/^MT/chrM/g" | sed "s/^X/chrX/g" | sed "s/^Y/chrY/g" > junctions_ucsc.bed
tail -n +2 coverage_ucsc.wig > coverage_ucsc.nh.wig
gzip coverage_ucsc.nh.wig
~/utilities/wigToBigWig coverage_ucsc.nh.wig.gz ~/utilities/mm9.chrom.sizes coverage_ucsc.bw
