#! /usr/bin/perl
###########################################################
# gal_check.pl - Check a pre-gal file for 384-well completeness.
# By Madelaine Gogol 
# 6/2007 
###########################################################

use strict;
use lib "/home/mcm";
use Locations;
my ($error,$letter,@numbers,$answer,$last_letter,$letter_count,$number,@items,$pregal_file,@lines,$count,$result);

$pregal_file = get_file_data($ARGV[0]);

@lines = split("\n",$pregal_file);

print "which of the following columns is the row (e.g. A, B, C...) where the first column is column 0 ?\n";
print "$lines[1]\n";
$number = <STDIN>;

print "Is it a position (e.g. A01), yes or no?\n";
$answer = <STDIN>;

$letter_count = 1;
$last_letter = "A";

foreach(@lines)
{
	if($answer eq "yes")
	{
		($letter,@numbers) = split('',$lines[$number]);
	}
	else
	{
		$letter = $lines[$number];
	}

	if($letter eq $last_letter)
	{
		$letter_count++;
		$last_letter = $letter;
	}
	else
	{
		if($letter_count != 24)
		{
			print "Error - $letter != 24\n";
			$error = 'true';
		}
		$letter_count = 1;
		$last_letter = $letter;
	}
	$count++;
}
if($error ne 'true')
{
	print "No errors detected in number of columns per row.\n";	
}

$result = $count/384;
print "$count / 384 = $result\n";


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

