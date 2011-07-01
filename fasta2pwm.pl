#! /usr/bin/perl
####################
# fasta2pwm.pl - given fasta format file output positional weight matrix. I'm going to use this with seqLogo in R.
# uses Bioperl
# By Madelaine Gogol
# 6/2011
####################

use strict;
use Bio::SeqIO;

my (%h,$defline,$sequence,$count,$in,$elements_to_print);

my $numseq = 0;
my $seqlen = 10;

$in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');
while(my $seq = $in->next_seq())
{
	$sequence = $seq->seq();
	$defline = $seq->display_id();

	my $pos = 0;
	foreach my $letter (split('',$sequence))
	{
		$h{$pos}{$letter} += 1;
		$pos++;
	}
	$numseq++;
}

my @letters = ('A','C','G','T');
foreach my $letter (@letters)
{
	for(my $i=0; $i < $seqlen; $i++)
	{
		my $val = $h{$i}{$letter}/$numseq;
		print "$val\t";
	}
	print "\n";
}
