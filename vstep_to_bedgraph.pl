#! /usr/bin/perl
####################
# vstep_to_bedgraph.pl - convert variable step wig to bed-style wig
# By Madelaine Gogol 
# 11/2008 
####################

use strict;

my ($start,$value,$end,$current_chrom,@lines,$filename, $contents, @chunks);
$filename = $ARGV[0];

#read in file
$contents = get_file_data($filename);

#split file at "variableStep lines"
@chunks = split(/\nvariableStep/,$contents);

#for each chromosome
foreach my $chunk (@chunks)
{
	@lines = split('\n',$chunk);
	foreach my $line (@lines)
	{
		#if the line starts with a number
		if($line =~ /^\d/)
		{
			($start,$value) = split(/\s+/,$line);
			$end = $start+1;

			#print out bedgraph format
			print "$current_chrom\t$start\t$end\t$value\n";
		}
		
		#otherwise, the line is a variableStep chrom=chr line
		elsif($line =~ /\schrom=(\S+)/)
		{
			$current_chrom = $1; #define current chromosome
		}
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
