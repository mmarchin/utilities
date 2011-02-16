#! /usr/bin/perl
####################
# truncwig.pl - given a chrom.sizes file and a single chromosome vstep wig file, truncate the wig so it doesn't go past the end of chrom.
# By Madelaine Marchin
# 7/2009
####################

use strict;
use DBI;
use lib "/home/mcm";
use Locations;
use POSIX;

my ($pos,$value,$chromsizes_filename,$wig_filename,$contents,@chromsizes,@wig,$junk,$rest,$wigchrom,$chrom,$length,$maxlen);

$chromsizes_filename = $ARGV[0];
$wig_filename = $ARGV[1];

$contents = get_file_data($chromsizes_filename);
@chromsizes = split(/\n/,$contents);

$contents = get_file_data($wig_filename);
@wig = split(/\n/,$contents);

foreach my $line (@chromsizes)
{
	($chrom,$length) = split("\t",$line);
	$hash{$chrom} = $length;
}

foreach my $line (@wig)
{
	($chrom,$start,$end,$value) = split("\t",$line);
	if($end < $hash{$chrom})
	{
		print "$line\n";
	}
	else
	{	
#		print "$chrom\t$start\t$end\t$hash{$chrom}\n";
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
