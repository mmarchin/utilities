#! /usr/bin/perl
####################
# make600.pl - given fasta format file splits sequence into overlapping 600mers by 100 bases.. 
# By Madelaine Marchin
# 2/2007
####################

use strict;

my ($length,$current_600,$filename, $contents, @chunks);
$filename = $ARGV[0];

$contents = get_file_data($filename);
@chunks = split(/>.*\n/,$contents);
my $count = 0;

foreach my $chunk (@chunks)
{
	$chunk = join('',split(/\n/,$chunk));
	#print "$chunk\n";

	$length = length($chunk);
	for(my $i=0; $i < $length; $i=$i+500)
	{
		$current_600 = substr($chunk,$i,600);
	
		print ">"."$count"."_"."$i\n";
		print "$current_600\n";
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
