#! /usr/bin/perl
####################
# bedtss.pl - go from chrom start end name score strand to tss (depends on strand).
# By Madelaine Gogol 
# 5/2011
####################

use strict;
use POSIX;
my ($start,$end,$chr,$midpoint,$filename,@columns,@lines,$contents,@items,$col,$i);
my ($value);

$filename = $ARGV[0];

$contents = get_file_data($filename);
@lines = split('\n',$contents);

foreach my $line (@lines)
{
	@items = split('\t',$line);

	if($items[5] eq "+")
	{
		$end = $items[1]+1;
		print "$items[0]\t$items[1]\t$end\t$items[3]\t$items[4]\t$items[5]\n";
	}
	elsif($items[5] eq "-")
	{
		$start = $items[2]-1;
		print "$items[0]\t$start\t$items[2]\t$items[3]\t$items[4]\t$items[5]\n";
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
