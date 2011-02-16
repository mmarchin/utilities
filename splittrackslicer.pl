#! /usr/bin/perl
####################
# splittrackslicer.pl - given track slicer file rearranges 
# By Madelaine Marchin
# 8/2007
####################

use strict;
my ($filename,@lines,$contents,$junk,$pos);

$filename = $ARGV[0];
$contents = get_file_data($filename);
@lines = split('\n',$contents);

foreach my $line (@lines)
{
	if($line =~ /^REGION/)
	{
		($junk,$pos)= split(" ",$line);
	}
	elsif($line =~ /^Chrom/)
	{
		
	}
	elsif($line =~ /^$/)
	{
	}
	else
	{
		print "chr"."$pos\t$line\n";
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
