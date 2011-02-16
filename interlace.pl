#! /usr/bin/perl
####################
# interlace.pl - given two files, print one line then the other.
# By Madelaine Gogol
# 6/2009
####################

use strict;

my ($file1,$file2,$contents1,$contents2,@lines1,@lines2);

$file1 = $ARGV[0];
$file2 = $ARGV[1];

$contents1 = get_file_data($file1);
$contents2 = get_file_data($file2);

@lines1 = split(/\n/,$contents1);
@lines2 = split(/\n/,$contents2);

if($#lines1 == $#lines2)
{
	for(my $i = 0; $i <= $#lines1; $i++)
	{
		print "$lines1[$i]\n";
		print "$lines2[$i]\n";
	}
}
else
{
	print "diff #s of lines: $#lines1 $#lines2\n";
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
