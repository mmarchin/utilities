#! /usr/bin/perl
####################
# bedlengths.pl - calc lengths of bed elements, sum 
# By Madelaine Gogol 
####################

use strict;
my ($contents, @lines,$filename,$chr1,$st1,$end1,$chr2,$st2,$end2,$midpoint1,$midpoint2,$dist);
my ($length);

$filename = $ARGV[0];

my $total = 0;
$contents = get_file_data($filename);
@lines = split('\n',$contents);

foreach my $line (@lines)
{
	($chr1,$st1,$end1) = split('\t',$line);

	$length = $end1-$st1;

	print "$chr1\t$st1\t$end1\t$length\n";

	#if using ensembl, make sure to add 1 to length! UCSC is 0-based.
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
