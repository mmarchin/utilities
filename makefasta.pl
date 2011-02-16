#! /usr/bin/perl
####################
# makefasta.pl - given command line arg of sequence file in format id tab sequence
# outputs in fasta format.  
# By Madelaine Marchin
# 3/1/2005
# updated 12/2006
####################

use strict;

my ($id,$sequence,$filename, $contents, @lines);
$filename = $ARGV[0];

$contents = get_file_data($filename);
@lines = split(/\n/,$contents);
foreach my $line (@lines)
{
	($id,$sequence) = split(/\t/,$line);
	print ">$id\n$sequence\n";
	#print ">$sequence\n$sequence\n";
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
