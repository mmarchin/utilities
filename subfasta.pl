#! /usr/bin/perl
####################
# subfasta.pl - given fasta format file and file with headers, keep fasta entries with headers from file.
# uses Bioperl
# By Madelaine Gogol
# 10/2008
####################

use strict;
use Bio::SeqIO;

my ($defline,$sequence,$count,$in,$elements_to_print);


my @selected_headers = split("\n",get_file_data($ARGV[0]));

#print "$#selected_headers\n";

for(my $i = 0; $i <= $#selected_headers ; $i++)
{
	#print "looking for: $selected_headers[$i]\n";
	$in = Bio::SeqIO->new(-file=>"$ARGV[1]", -format=>'Fasta');
	while(my $seq = $in->next_seq())
	{
		$sequence = $seq->seq();
		$defline = $seq->display_id();

		if($defline eq $selected_headers[$i])
		{
			print ">$defline\n$sequence\n";
		}
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
