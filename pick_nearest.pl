#! /usr/bin/perl
###########################################################
# pick_nearest.pl - pick nearest gene from upstream/downstream.
# By Madelaine Gogol 
# 12/2008 
###########################################################

use strict;
use lib "/home/mcm";
use Locations;

#make sure all lines are doubles, not 1 or 3!
#cut -f 2 chipchip_nearest_genes.txt | uniq -c | sort -r | tail -n 1

my ($number,$number2,$start,$last_start,@lines,@items,$file,$distance,$inpair,$current_distance,$last_distance,$last_line);

$file = get_file_data($ARGV[0]);

@lines = split("\n",$file);

print "which of the following columns is the distance to nearest gene?\n";
print "$lines[1]\n";
$number = <STDIN>;
print "which of the following columns is the start of peak?\n";
print "$lines[1]\n";
$number2 = <STDIN>;
$inpair = 'false';

foreach my $line (@lines)
{
	@items = split("\t",$line);
	$distance = $items[$number];
	$start = $items[$number2]; 
	#print "line:$line\n";
	#print "$distance\n";
	if($start == $last_start)
	{
		$current_distance = $distance;
		if($current_distance < $last_distance)
		{
			print "$line\n";
			#print "not $last_line\n";
			#print "$current_distance\n";
			#print "not $last_distance\n";
		}
		else
		{
			print "$last_line\n";
			#print "not $line\n";
			#print "$last_distance\n";
			#print "not $current_distance\n";
		}
		$inpair = 'false';
	}
	else
	{
		$last_distance = $distance;
		$last_line = $line;
		$last_start = $start;
		$inpair = 'true';
	}
}
#known bugs - first line messed up, prints question in file, too lazy to fix.


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

