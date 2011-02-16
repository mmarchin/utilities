#! /usr/bin/perl
####################
# double.pl - given a file, print every line double, keeping start and then end..
# By Madelaine Gogol
# 6/2009
####################

use strict;

my ($a,$b,$c,$d,$file,$contents,@lines);


$file = $ARGV[0];

$contents = get_file_data($file);

@lines = split(/\n/,$contents);
shift(@lines);

for(my $i = 0; $i <= $#lines; $i++)
{
	my ($chrom,$fbid,$genename,$transcript,$exon,$exonstart,$exonend,$exonstrand) = split("\t",$lines[$i]);

	$a = $exonstart - 1;
	$b = $exonstart + 1;
	$c = $exonend - 1;
	$d = $exonend + 1;
	
	print "$chrom\t$fbid\t$genename\t$transcript\t$exon\t$a\t$b\t$exonstrand\n";
	print "$chrom\t$fbid\t$genename\t$transcript\t$exon\t$c\t$d\t$exonstrand\n";
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
