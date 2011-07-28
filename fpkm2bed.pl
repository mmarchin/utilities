#! /usr/bin/perl
####################
# fpkm2bed.pl - given cufflinks 1.0.3 genes.fpkm_tracking file, make bed file with score of fpkm
# By Madelaine Gogol
# 7/2011
####################

use strict;
my ($chrom,$name,$junk,$chrpos,$fpkm,$startend,$start,$end);

while(<>)
{
	chomp;
	next if /^tracking_id/;
	($name,$junk,$junk,$junk,$junk,$junk,$chrpos,$junk,$junk,$junk,$fpkm,$junk,$junk) = split("\t",$_);
	($chrom,$startend) = split(":",$chrpos);
	($start,$end) = split("-",$startend);
	print "$chrom\t$start\t$end\t$name\t$fpkm\t+\n";
}
