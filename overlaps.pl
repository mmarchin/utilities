#! /usr/bin/perl
####################
# overlaps.pl - given two files, find out where they overlap (like galaxy). 
# By Madelaine Gogol
# 3/11/2008
####################

use strict;

my ($grep1,$grep2,$j1,$j2,$chrom1,$chrom2,$start1,$start2,$end1,$end2,@junk1,@junk2,$filename1,$filename2,$contents1,$contents2,@lines1,@lines2);
$filename1 = $ARGV[0];
$filename2 = $ARGV[1];

#open(LOG,">overlap.log");
#print LOG "$filename1 $filename2\n";
#multi-column sort by chrom,start.

$grep1 = `grep -n track $filename1`;
$grep2 = `grep -n track $filename2`;
#print LOG "grep1:$grep1 grep2:$grep2\n";

if($grep1=~m/^1:/)
{
	`tail -n +2 $filename1 > $filename1.nh`;
}
else
{
	`cat $filename1 > $filename1.nh`;
}
if($grep2=~m/^1:/)
{
	`tail -n +2 $filename2 > $filename2.nh`;
}
else
{
	`cat $filename2 > $filename2.nh`;
}

`sed 's/chr//g' $filename1.nh | sort +0d -1 +1n -2 > $filename1.sort`;
`sed 's/chr//g' $filename2.nh | sort +0d -1 +1n -2 > $filename2.sort`;

$contents1 = get_file_data($filename1.".sort");
$contents2 = get_file_data($filename2.".sort");

`rm -f $filename1.sort`;
`rm -f $filename2.sort`;

@lines1 = split(/\n/,$contents1);
@lines2 = split(/\n/,$contents2);


my $done = 'false';

my $i = 0;
my $j = 0;

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
			
			print "chr"."$chrom1\t$start2\t$end2\t$j1\t$j2\n";	
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

			print "chr"."$chrom1\t$start2\t$end1\t$j1\t$j2\n";
			$i++;
		}
		elsif($end2 <= $end1 and $end2 >= $start1)
		{
			#print "chr"."$chrom1 $start1 $end1 --- chr"."$chrom2 $start2 $end2\n";
			#print "    _____\n";
			#print "______\n";

			print "chr"."$chrom1\t$start1\t$end2\t$j1\t$j2\n";
			$j++;
		}
	}
	else
	{
		#print "no_chr chr"."$chrom1 $start1 $end1 --- chr"."$chrom2 $start2 $end2\n";
		#move down whichever is behind...?
		if($chrom1 lt $chrom2) #what if chromosomes are not numeric?
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

`rm -f $filename1.nh`;
`rm -f $filename2.nh`;


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
