#! /usr/bin/perl
####################
# renamebed.pl - rename any non-unique bed names to append a digit
# By Madelaine Gogol 
# 2/2014
####################

use strict;

my $filename = $ARGV[0];

my ($val,%h,$new,$chrom,$start,$end,$name,$score,$strand);

open(bed,"$filename");

while(<bed>)
{
	chomp;
	($chrom,$start,$end,$name,$score,$strand) = split("\t",$_);
	if(exists($h{$name}))
	{
		$val = $h{$name} + 1;
		$new = "$name.$val";
		print "$chrom\t$start\t$end\t$new\t$score\t$strand\n";
		$h{$name} = $val;
	}
	else
	{
		print "$chrom\t$start\t$end\t$name\t$score\t$strand\n";
		$h{$name} = 0;
	}
}
