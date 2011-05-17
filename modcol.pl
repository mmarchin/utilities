#! /usr/bin/perl
####################
# modcol.pl - modify a column. 
# By Madelaine Gogol 
# 7/2003
####################

use strict;
my ($filename,@columns,@lines,$contents,@items,$col,$i);
my ($value);

$filename = $ARGV[0];
#shift(@ARGV);
#@columns = @ARGV;

$contents = get_file_data($filename);
@lines = split('\n',$contents);

foreach my $line (@lines)
{
	@items = split('\t',$line);

	$value = $items[1] + 1;

	print "$items[0]\t$items[1]\t$value\t$items[2]\n";
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
