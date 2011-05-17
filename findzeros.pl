#! /usr/bin/perl
####################
# findzeros.pl - given a wig file, output bed file of zero regions. 
# By Madelaine Gogol 
# 3/2010
####################

use strict;
use DBI;
use lib "/home/mcm";
use Locations;
use POSIX;

my ($last_start,$last_val,$filename,$dbh,$sth,$contents,@lines,$query,$chrom,$start,$end,$value,$offset,$window,$count);

$filename = $ARGV[0];

$contents = get_file_data($filename);
@lines = split(/\n/,$contents);

foreach my $line (@lines)
{
	if($line =~ /^track/)
	{
		print "$line\n";
	}
	else
	{
		my ($chrom, $start, $end, $value) = split /\t/, $line;
		if($value < 0.001 and $value < $last_val and $last_val > 0.001)
		{
			#peak.
			
			print "$chrom\t$last_start\t$end\n";
			$last_start = $start;
			$last_val = $value;
		}
		else
		{
			$last_start = $start;
			$last_val = $value;
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
