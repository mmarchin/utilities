#! /usr/bin/perl
####################
# flatten.pl - given fasta format file >id|chrom|start|end \n sequence
# outputs id\tsequence. 
# uses Bioperl
# By Madelaine Marchin
# 3/1/2005
# updated 12/2005
####################

use strict;
use Bio::SeqIO;

my ($split,$chunk,$id,$chrom,$start,$end,$strand_offset,$defline,$sequence,$in);

$in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');
$split = $ARGV[1];

while(my $seq = $in->next_seq())
{
	$sequence = $seq->seq();
	$defline = $seq->display_id();
	if($defline =~ /\|/)
	{
		($id,$chrom,$start,$end,$strand_offset) = split(/\|/,$defline);
	}
	else
	{
		$id = $defline;
	}

	for(my $i = 0; $i <= length($sequence); $i = $i + $split)
	{
		$chunk = substr($sequence,$i,$split);
		print ">$id.$i\n$chunk\n";
	}
}

