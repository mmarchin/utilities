#! /usr/bin/perl
####################
# breakfasta.pl - split a fasta file into indiv files for each record.
# uses Bioperl
# By Madelaine Gogol
# 4/2011
####################

use strict;
use Bio::SeqIO;
use File::Basename;

my ($split,$chunk,$id,$chrom,$start,$end,$strand_offset,$defline,$sequence,$in);

$in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');
my $dir = dirname($ARGV[0]);

while(my $seq = $in->next_seq())
{
	$sequence = $seq->seq();
	$defline = $seq->display_id();
	#my ($num,$name,$color1,$color2) = split("_",$defline);
	open(OUT,">$dir/$defline.fa") or die "Can't open file $!";
	print OUT ">$defline\n$sequence\n";
}

