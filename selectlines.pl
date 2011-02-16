#! /usr/bin/perl
####################
# selectlines.pl - given file with header and number, print every numberth line
# By Madelaine Marchin
# 12/2008
####################

use strict;
my ($number,$filename,@lines,$contents,$i);

$filename = $ARGV[0];
$number = $ARGV[1];

$contents = get_file_data($filename);
@lines = split('\n',$contents);
shift(@lines);

foreach my $line (@lines)
{
	if($i == $number - 1)
	{
		$i=0;
		print "$line\n";
	}
	else
	{
		$i++;
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
