#! /usr/bin/perl
####################
# make70.pl - given fasta format file splits sequence into overlapping 70mers by one base.. 
# By Madelaine Marchin
# 2/2007
####################

use strict;

my ($length,$current_70,$filename, $contents, @chunks);
$filename = $ARGV[0];

$contents = get_file_data($filename);
@chunks = split(/>.*\n/,$contents);

foreach my $chunk (@chunks)
{
	$chunk = join('',split(/\n/,$chunk));
	#print "$chunk\n";

	$length = length($chunk);
	for(my $i=0; $i < $length; $i++)
	{
		$current_70 = substr($chunk,$i,70);
	
		print ">$i\n";
		print "$current_70\n";
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
