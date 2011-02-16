#! /usr/bin/perl
####################
# pair_ends.pl - given a bed file with ids (sorted by id), make joined bed file
# By Madelaine Gogol 
# 9/2009 
####################

use strict;
my ($count,$junk,$mult_contents,$mult_line,@mult_lines,$offset,$first_size,$second_size,$filename,@lines,$contents,$chrom,$start,$end,$id,$score,$strand,$last_id,$last_chrom,$last_start,$last_end,$last_strand,$last_score,$interval);


#example of bed format...
#chr9       3013522 3014031 JUNC00000002    1       +       3013522 3014031 255,0,0 2       15,27   0,482

$filename = $ARGV[0];

#sort by the chrom column, then id column, then start column numerically.
`sort -k1,1 -k4,4 -k2,2n $ARGV[0] > temp.sort`;

#find any multiple mapping mate pairs?

`cut -f4 temp.sort | uniq -c | sort -nr > temp.count`;
$mult_contents = get_file_data("temp.count");
@mult_lines = split("\n",$mult_contents);
foreach my $mult_line (@mult_lines)
{
	#print "m:$mult_line\n";
	($count,$id) = split(" ",$mult_line);
	#print "j:$junk c:$count i:$id\n";
	if($count > 2)
	{
		print "warning: $id had mult matches!\n";
	}
	else
	{
		last;
	}
}

$contents = get_file_data("temp.sort");
@lines = split('\n',$contents);

$interval = "closed";

foreach my $line (@lines)
{
	($chrom,$start,$end,$id,$score,$strand) = split('\t',$line);

	#what if there are more than two mate pair mapping regions? 

	#if chrom eq last chrom and open and this id is equal to last id, join and print, close
	if($chrom eq $last_chrom and $interval eq "open" and $id eq $last_id)
	{
		$interval = "closed";
		#print "$id equals $last_id!\n";
		$second_size = $end-$start;
		$first_size = $last_end-$last_start;
		$offset = $start-$last_start;
		print "$chrom\t$last_start\t$end\t$id\t$score\t$strand\t$last_start\t$end\t0,0,0\t2\t$first_size,$second_size\t0,$offset\n";
	}
	#else if chrom eq last chrom and open and this id is different, open and print last.
	elsif($chrom eq $last_chrom and $interval eq "open" and $id ne $last_id)
	{
		$interval = "open";
		#print "no match $last_id\n";
		$first_size = $last_end-$last_start;
		print "$last_chrom\t$last_start\t$last_end\t$last_id\t$last_score\t$last_strand\t$last_start\t$last_end\t0,0,0\t1\t$first_size\t0\n";
	}
	#else if closed or new chrom, open.
	else
	{
		$interval = "open";
	}
	$last_id = $id;
	$last_chrom = $chrom;
	$last_start = $start;
	$last_end = $end;
	$last_strand = $strand;
	$last_score = $score;
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
