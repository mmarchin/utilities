#! /usr/bin/perl
####################
# renamefasta.pl - given command line arg of sequence file in format id tab sequence
# outputs in fasta format, renaming the annotation lines. 
# By Madelaine Gogol 
# 6/2007 
####################

use strict;

# to convert fasta first, use VI.

# %s/\(>.*\)\n/\1^I/g
my ($new_annotation,$filename,$contents,@lines,$label,$id,$sequence);
$filename = $ARGV[0];
$new_annotation = $ARGV[1];

$contents = get_file_data($filename);
@lines = split(/\n/,$contents);
$label = 1;
foreach my $line (@lines)
{
	($id,$sequence) = split(/\t/,$line);
	print ">$new_annotation".$label."\n$sequence\n";
	$label = $label+1;
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
