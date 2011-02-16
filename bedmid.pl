#! /usr/bin/perl
####################
# bedmid.pl - go from chrom start end id to id chrom no chr, midpoint.
# By Madelaine Gogol 
# 4/2010
####################

use strict;
use POSIX;
my ($chr,$midpoint,$filename,@columns,@lines,$contents,@items,$col,$i);
my ($value);

$filename = $ARGV[0];

$contents = get_file_data($filename);
@lines = split('\n',$contents);

foreach my $line (@lines)
{
	@items = split('\t',$line);

	$midpoint = floor(($items[2] - $items[1])/2) + $items[1];

	$chr = $items[0];
	$chr =~ s/^chr//g;

	print "$items[3]\t$chr\t$midpoint\n";
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
