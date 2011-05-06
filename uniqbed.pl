#! /usr/bin/perl
####################
# uniqbed.pl -  how many times  is a given column  duplicated in a bed file.
# By Madelaine Gogol 
# 4/2011
####################

use strict;
use POSIX;
my (@items,$column, $count, %h,$item,$contents, @lines,$filename,$chr1,$st1,$end1,$chr2,$st2,$end2,$midpoint1,$midpoint2,$dist);
my ($length);

$filename = $ARGV[0];
$column= $ARGV[1];

`cut -f $column $filename | sort | uniq -c > counts.txt`;

open(bed,"$filename");
open(counts,"counts.txt");

while(<counts>)
{
	chomp;
	($count,$item) = split(" ",$_);
	$h{$item} = $count;
#	print "$item:$count\n";
}

while(<bed>)
{
	chomp;
	@items = split("\t",$_);
	$count = $h{$items[$column-1]};
	print "$_\t$count\n";
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
