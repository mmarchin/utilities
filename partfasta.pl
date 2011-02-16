#! /usr/bin/perl
####################
# partfasta.pl - given fasta format file and count, return first count elements.
# uses Bioperl
# By Madelaine Gogol
# 10/2008
####################

use strict;
use Bio::SeqIO;

my ($defline,$sequence,$count,$in,$elements_to_print);


my $elements_to_print = $ARGV[0];
$in = Bio::SeqIO->new(-file=>"$ARGV[1]", -format=>'Fasta');
$count = 0;

while(my $seq = $in->next_seq())
{
	$sequence = $seq->seq();
	$defline = $seq->display_id();

	if($count < $elements_to_print)
	{
		print ">$defline\n$sequence\n";
	}

	$count++;
}

