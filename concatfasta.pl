#! /usr/bin/perl
####################
# concatfasta.pl - given fasta format concats sequences into one big sequence with N's in between. 
# By Madelaine Marchin
# 5/7/2007
####################

use strict;

my ($filename, $contents, @chunks);
$filename = $ARGV[0];

$contents = get_file_data($filename);
@chunks = split(/\n>.*\n/,$contents);
shift(@chunks);
my $i = 0;
print ">eejt\n";
foreach my $chunk (@chunks)
{
	$chunk = join('',split(/\n/,$chunk));
	print "$chunk";
	for(my $i=0; $i<50; $i++)
	{
		print "N";
	}
}
print "\n";

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
