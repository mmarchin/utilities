#! /usr/bin/perl
####################
# splitter_to_bed.pl - convert splitter output to bed output 
# By Madelaine Gogol 
# 7/2003
####################

use strict;
my ($trackname,$filename,$contents,@lines,@items,$chrom,$startend,$start,$end);

$filename = $ARGV[0];

$contents = get_file_data($filename);
@lines = split('\n',$contents);
shift(@lines);

$trackname = $filename;
$trackname=~s/.splitter//g;
print "track name=$trackname\n";
foreach my $line (@lines)
{
	@items = split('\t',$line);
	($chrom,$startend) = split(":",$items[0]);
	($start,$end) = split("-",$startend);
	print "$chrom\t$start\t$end\t$items[1]\n";
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
