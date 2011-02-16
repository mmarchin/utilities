#! /usr/bin/perl
####################
# inclusive_overlaps.pl - given two files, find out where they overlap (like galaxy). Include the whole region of the first argument. 
# By Madelaine Gogol
# 3/11/2008
####################

use strict;

my ($j1,$j2,$chrom1,$chrom2,$tempchrom1,$tempchrom2,$tempstart1,$tempstart2,$tempend1,$tempend2,@tempjunk1,@tempjunk2,$start1,$start2,$end1,$end2,@junk1,@junk2,$filename1,$filename2,$contents1,$contents2,@lines1,@lines2);
$filename1 = $ARGV[0];
$filename2 = $ARGV[1];

#multi-column sort by chrom,start.

`sed 's/chr//g' $filename1 | sort +0d -1 +1n -2 > $filename1.tmp`;
`sed 's/chr//g' $filename2 | sort +0d -1 +1n -2 > $filename2.tmp`;

$contents1 = get_file_data($filename1.".tmp");
$contents2 = get_file_data($filename2.".tmp");

@lines1 = split(/\n/,$contents1);
@lines2 = split(/\n/,$contents2);

my $done = 'false';

my $i = 1;
my $j = 1;

($chrom1,$start1,$end1,@junk1) = split("\t",$lines1[$i]);
($chrom2,$start2,$end2,@junk2) = split("\t",$lines2[$j]);

$j1 = join("\t",@junk1);
$j2 = join("\t",@junk2);

while($done eq 'false')
{
	if($chrom1 eq $chrom2)
	{
		if($end1 < $start2)
		{
			#print "no chr"."$chrom1 $start1 $end1 --- chr"."$chrom2 $start2 $end2\n";
			#no overlap, move down the min one.
			$i++;
		}
		elsif($start1 > $end2)
		{
			#print "no chr"."$chrom1 $start1 $end1 --- chr"."$chrom2 $start2 $end2\n";
			$j++;	
		}
		elsif($start1 <= $start2 and $end1 >= $end2)
		{
			#print "chr"."$chrom1 $start1 $end1 --- chr"."$chrom2 $start2 $end2\n";
			#print "_______\n";
			#print "   __\n";
			
			print "chr"."$chrom1\t$start1\t$end1\t$j1\t$j2\n";	
			$j++;
		}
		elsif($start1 >= $start2 and $end1 <= $end2)
		{
			#print "chr"."$chrom1 $start1 $end1 --- chr"."$chrom2 $start2 $end2\n";
			#print "   ___   \n";
			#print "__________\n";

			print "chr"."$chrom1\t$start1\t$end1\t$j1\t$j2\n";
			$i++;
		}
		elsif($start1 <= $start2 and $end1 >= $start2)	
		{
			#print "chr"."$chrom1 $start1 $end1 --- chr"."$chrom2 $start2 $end2\n";
			#print "______   \n";
			#print "   _______\n";

			print "chr"."$chrom1\t$start1\t$end1\t$j1\t$j2\n";
			$i++;
		}
		elsif($end2 <= $end1 and $end2 >= $start1)
		{
			#print "chr"."$chrom1 $start1 $end1 --- chr"."$chrom2 $start2 $end2\n";
			#print "    _____\n" first argument first argument first argument first argument first argument.....;
			#print "______\n";

			print "chr"."$chrom1\t$start1\t$end1\t$j1\t$j2\n";
			$j++;
		}
	}
	else
	{
		#print "no_chr chr"."$chrom1 $start1 $end1 --- chr"."$chrom2 $start2 $end2\n";
		#move down whichever is behind...?
		if($chrom1 lt $chrom2)
		{
			$i++;
		}
		else
		{
			$j++;
		}	
	}
	

	if($i <= $#lines1 and $j <= $#lines2)
	{
		($chrom1,$start1,$end1,@junk1) = split("\t",$lines1[$i]);
		($chrom2,$start2,$end2,@junk2) = split("\t",$lines2[$j]);
		$j1 = join("\t",@junk1);
		$j2 = join("\t",@junk2);
	}
	else
	{
		$done = "true";
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
