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

my ($id,$chrom,$start,$end,$strand_offset,$defline,$sequence,$in);

$in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');

while(my $seq = $in->next_seq())
{
	$sequence = $seq->seq();
	$defline = $seq->display_id();
	print "$defline\t$sequence\n";
}

