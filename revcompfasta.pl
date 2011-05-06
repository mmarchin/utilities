#! /usr/bin/env perl
####################
# revcompfasta.pl - given fasta format file, rev comp seqs.
# uses Bioperl
# By Madelaine Gogol
# 10/2008
####################

use strict;
use Bio::SeqIO;

my ($revcomp,$defline,$sequence,$count,$in,$elements_to_print);

$in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');
while(my $seq = $in->next_seq())
{
	$sequence = $seq->seq();
	$defline = $seq->display_id();

	$revcomp = revcompl($sequence);

	print ">$defline\n$revcomp\n";
}

######################################################    
# subroutine get_file_data
# arguments: filename
# purpose: gets data from file given filename;
# returns file contents
######################################################

sub get_file_data
{
        my($filename) = @_;

        my @filedata = ();

        unless( open(GET_FILE_DATA, $filename))
        {
                print STDERR "Cannot open file \"$filename\": $!\n\n";
                exit;
        }
        @filedata = <GET_FILE_DATA>;
        close GET_FILE_DATA;
        return join('',@filedata);
}

sub revcompl
{
	my ($dna) = @_;
	my $revcomp = reverse($dna);
	$revcomp =~ tr/ACGTacgt/TGCAtgca/;
	return $revcomp;
}
