#! /usr/bin/perl
####################
# random_bed.pl - given a bed file and chrom, lengths, generate a random bed file
# By Madelaine Gogol
# 6/2009
####################

use strict;

my (@chromindexes,$numchrom,$Rcommand,@junk,$junk,$start,$end,$chrom_file,$bed_file,$contents,@lines,$i,$j,$chromindex,@chrom,@chrom_length,@length);
$chrom_file = $ARGV[0];
$bed_file = $ARGV[1];

$contents = get_file_data($chrom_file);
@lines = split(/\n/,$contents);
$i=0;
foreach my $line (@lines)
{
	($chrom[$i],$chrom_length[$i]) = split("\t",$line);
	$i++;
}

$contents = get_file_data($bed_file);
@lines = split(/\n/,$contents);
if($lines[0]=~/^track.*\n/)
{
	shift(@lines);
}
$j=0;
foreach my $line (@lines)
{
	($junk,$start,$end,@junk) = split("\t",$line);
	$length[$j] = $end - $start;
	$j++;
}

#get random chromosomes (based on lengths)
$numchrom=$#chrom+1;
$Rcommand = "cat ~/utilities/get_chroms.R | R --slave --args $numchrom $j @chrom_length";
#print "$Rcommand\n";
@chromindexes=split(" ",`$Rcommand`);
#print "@chromindexes\n";

srand(time ^ $$);
for(my $i = 0; $i < $j; $i++)
{
	$start = int(rand($chrom_length[$chromindexes[$i]]));
	$end = $start + $length[$i];
	print "$chrom[$chromindexes[$i]]\t$start\t$end\n";
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
