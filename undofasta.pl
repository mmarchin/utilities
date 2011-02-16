#! /usr/bin/perl
####################
# undofasta.pl - given fasta format file strips annotation and outputs result to stdout. 
# By Madelaine Marchin
# 3/1/2005
####################

use strict;

my ($filename, $contents, @chunks);
$filename = $ARGV[0];

$contents = get_file_data($filename);
@chunks = split(/\n>.*\n/,$contents);
shift(@chunks);
my $i = 0;
foreach my $chunk (@chunks)
{
	$chunk = join('',split(/\n/,$chunk));
	print "$chunk\n";
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
