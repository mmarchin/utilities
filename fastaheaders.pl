#! /usr/bin/perl
####################
# fastaheaders.pl - given fasta format file print headers.
# uses Bioperl
# By Madelaine Gogol
# 9/2009
####################

use strict;
use Bio::SeqIO;

my ($defline,$sequence,$count,$in,$elements_to_print);


$in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');

while(my $seq = $in->next_seq())
{
	$defline = $seq->display_id();

	print "$defline\n";
}

