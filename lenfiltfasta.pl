#! /usr/bin/perl
####################
# lenfiltfasta.pl - given fasta format file and length, keep fasta entries  > length.
# uses Bioperl
# By Madelaine Gogol
# 10/2008
####################

use strict;
use Bio::SeqIO;

my ($defline,$sequence,$count,$in,$elements_to_print);

my $length = $ARGV[1];

$in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');
while(my $seq = $in->next_seq())
{
	$sequence = $seq->seq();
	$defline = $seq->display_id();

	if(length($sequence) > $length)
	{
		print ">$defline\n$sequence\n";
	}
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
