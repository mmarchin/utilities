#! /usr/bin/perl
####################
# sumbed.pl - calc lengths of bed elements, sum 
# By Madelaine Gogol 
# 7/2003
####################

use strict;
use POSIX;
my ($strand,$name,$sum,$score,$contents, @lines,$filename,$chr1,$st1,$end1,$chr2,$st2,$end2,$midpoint1,$midpoint2,$dist);
my ($length);

$filename = $ARGV[0];

my $total = 0;
my $sum = 0;
$contents = get_file_data($filename);
@lines = split('\n',$contents);

foreach my $line (@lines)
{
	($chr1,$st1,$end1,$name,$score,$strand) = split('\t',$line);

	#$sum = $sum + $score;
	$sum = $sum + ($end1-$st1);

	#if using ensembl, make sure to add 1 to length! UCSC is 0-based.
}

print "$sum\n";
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
