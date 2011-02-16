#! /usr/bin/perl
####################
# uc.pl - given fasta format file make sequence uppercase
# uses Bioperl
# By Madelaine Gogol 
# 4/29/2008
####################

use strict;
use Bio::SeqIO;

my ($in,$sequence,$defline,$uc);

$in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');

while(my $seq = $in->next_seq())
{
	$sequence = $seq->seq();
	$defline = $seq->display_id();
	$uc = uc($sequence);
	print ">$defline\n$uc\n";
}

