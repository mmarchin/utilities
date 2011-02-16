#! /usr/bin/perl
####################
# fastq2flat.pl - given fastq, only print seqs. 
# By Madelaine Gogol
# 11/2010
####################

use strict;

my $i = 2;
while(<>)
{
	if($i == 3)
	{
		$i=0;
		print "$_";
	}
	else
	{
		$i++;
	}
}
