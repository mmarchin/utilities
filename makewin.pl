#! /usr/bin/perl
####################
# makewin.pl - given fasta format file splits sequence into non-overlapping 100mers. 
# By Madelaine Marchin
# 8/2007
####################

use strict;

my ($length,$current_100,$filename, $contents, @chunks);
$filename = $ARGV[0];

$contents = get_file_data($filename);
@chunks = split(/>.*\n/,$contents);

foreach my $chunk (@chunks)
{
	$chunk = join('',split(/\n/,$chunk));
	#print "$chunk\n";

	$length = length($chunk);
	for(my $i=0; $i < $length; $i=$i+100)
	{
		$current_100 = substr($chunk,$i,100);
	
		print ">$i\n";
		print "$current_100\n";
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
