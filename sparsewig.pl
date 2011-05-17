#! /usr/bin/perl
####################
# sparsewig.pl - remove 1 in X probes from wig. 
# By Madelaine Marchin
# 7/2006
####################

use strict;
use DBI;
use lib "/home/mcm";
use Locations;
use POSIX;

my ($lasttrack,$filename,$dbh,$sth,$contents,@lines,$query,$chrom,$start,$end,$value,$offset,$window,$count);

$filename = $ARGV[0];
my $remove_rate = 4; # one in how many?

$contents = get_file_data($filename);
@lines = split(/\n/,$contents);
$count = 0;

foreach my $line (@lines)
{
	if($line =~ /^track/)
	{
		print "$line\n";
	}
	else
	{	
		($chrom,$start,$end,$value) = split(/\t/,$line);
	
		if($chrom ne "")
		{
			if($count % $remove_rate==0)
			{
			}
			else
			{
				print "$chrom\t$start\t$end\t$value\n";	
			}
		}
	}
	$count++;
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
