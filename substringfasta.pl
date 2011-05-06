#! /usr/bin/env perl
####################
# substringfasta.pl - given fasta format file, start, and length, return substring for each element.
# uses Bioperl
# By Madelaine Gogol
# 4/2011
####################

use strict;
use Bio::SeqIO;

my ($start,$length,$name,$defline,$in,$sequence,$newseq);

$in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');
$name = $ARGV[1];
$start = $ARGV[2];
$length = $ARGV[3];

while(my $seq = $in->next_seq())
{
	$sequence = $seq->seq();
	$defline = $seq->display_id();

	if($length)
	{
		$newseq = substr($sequence,$start,$length);
	}
	else
	{
		$newseq = substr($sequence,$start);
	}

	print ">$defline.$name\n$newseq\n";
}

