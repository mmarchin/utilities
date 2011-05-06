#! /usr/bin/env perl
####################
# revfasta.pl - given fasta format file, rev seqs.
# uses Bioperl
# By Madelaine Gogol
# 10/2008
####################

use strict;
use Bio::SeqIO;

my ($rev,$defline,$sequence,$count,$in,$elements_to_print);

$in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');
while(my $seq = $in->next_seq())
{
	$sequence = $seq->seq();
	$defline = $seq->display_id();

	$rev = reverse($sequence);

	print ">$defline\n$rev\n";
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
