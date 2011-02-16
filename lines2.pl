#! /usr/bin/perl
###########################################################
# lines.pl - outputs some info about line lengths. Call with name of fasta file.
# By Madelaine Marchin
# 5/2006 
###########################################################

use strict;
use Bio::SeqIO;
use lib "/home/mcm";
use Locations;

my ($shortest_length,$longest_length,$shortest_defline,$shortest_seq,$longest_defline,$longest_seq,$mean,$count,$sum_of_lengths,$defline,$sequence,$length);
open(OUT, ">lengths.txt") or die("Can't open lengths.txt: $!");
my $in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');


$shortest_length = 100000000000000;
$longest_length = 0;
$sum_of_lengths = 0;
$count = 0;
while(my $seq = $in->next_seq())
{
        $defline = $seq->display_id();
	$sequence = $seq->seq();
	$length = length($sequence);
	print OUT "$defline\t$length\n";
	if($length < $shortest_length)
	{
		$shortest_length = $length;
		$shortest_seq = $sequence;
		$shortest_defline = $defline;
	}
	elsif($length > $longest_length)
	{
		$longest_length = $length;
		$longest_seq = $sequence;
		$longest_defline = $defline;
	}
	$sum_of_lengths = $sum_of_lengths + $length;
	$count++;
}
print "sum of lengths:$sum_of_lengths\n";
print "count:$count\n";
#print "shortest sequence:$shortest_length\t$shortest_defline\t$shortest_seq\n";
#print "longest sequence:$longest_length\t$longest_defline\t$longest_seq\n";
$mean = $sum_of_lengths/$count;
print "mean:$mean\n";

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

