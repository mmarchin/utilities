#! /usr/bin/perl
####################
# remove_overlaps.pl - given a sorted file, get rid of overlaps (like for wig files). 
# By Madelaine Gogol
# 6/2008
####################

use strict;

my ($sorted_file,$contents,@lines,$last_chrom,$last_end,@data,$chrom,$start,$end,$value);

#to sort a chr	start end score file, use sort +0d -1 +1n -2 temp

$sorted_file = $ARGV[0];
$contents = get_file_data($sorted_file);
@lines = split("\n",$contents);


$last_chrom = $ARGV[1]; #should be first chrom.
$last_end = -1;

foreach my $line (@lines)
{
	if($line =~ /^track/)
	{
		print "$line\n";
	}
	else
	{

		@data = split("\t",$line);
		$chrom = $data[0];
		$start = $data[1];
		$end = $data[2];
		$value = $data[3];
		if($value eq "NA")
		{
			$value = 0;
		}

		if($chrom and $start and $end and $start > $last_end)
		{
			print "$chrom\t$start\t$end\t$value\n";
			$last_end = $end;
			$last_chrom = $chrom;
		}
		else
		{
			if($chrom ne $last_chrom)
			{
				$last_end = -1;
				if($chrom and $start and $end and $start > $last_end)
				{
					print "$chrom\t$start\t$end\t$value\n";
					$last_chrom = $chrom;
					$last_end = $end;
				}
			}
			elsif($chrom and $start and $end and $end > $last_end) #print out non-overlapping part.
			{
				print "$chrom\t$last_end\t$end\t$value\n";
				$last_chrom = $chrom;
				$last_end = $end;
			}
			elsif($chrom and $start and $end and $end == $last_end) #if they overlap exactly, just add one and hope it works out...
			{
				my $temp = $last_end + 1;
				print "$chrom\t$last_end\t$temp\t$value\n";
				$last_end = $temp;
			}
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
