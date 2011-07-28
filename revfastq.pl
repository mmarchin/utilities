#! /usr/bin/perl
####################
# revfastq.pl - given fastq, reverse sequences and quals 
# By Madelaine Gogol
# 7/2011
####################

use strict;

#@HWI-ST155_0615:1:1101:1104:2021#0/1
#ANTCCAGGCATCAGTAGAGTGTGAACTCTGACTTCTGTGCATTCTAAAGGGTACGGCAGAGCTCTCATCTGTTTTAAAGTCGCCCAGAAACAGATGCAAAA
#+HWI-ST155_0615:1:1101:1104:2021#0/1
#aBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB

my $i = 0;
while(<>)
{
	chomp;
	if($i == 1)
	{
		$i=0;
		my $new = reverse($_);
		print "$new\n";
	}
	else
	{
		print "$_\n";
		$i++;
	}
}
