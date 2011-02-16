#! /usr/bin/perl
###########################################################
# squish.pl - reads fasta file, removes extraneousness 
# By Madelaine Gogol
# 6/2007
###########################################################

use strict;
use Bio::SeqIO;
use lib "/home/mcm";
use Locations;
my ($count,$defline,$sequence,@lines);
$count = 0;

my $in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');

while(my $seq = $in->next_seq())
{
        $defline = $seq->display_id();
	$sequence = $seq->seq();
	push(@lines,"$defline\t$sequence\n");
	$count++;
}

foreach(@lines)
{
	($defline,$sequence) = split("\t",$_);
	print ">$defline\n$sequence";
}
