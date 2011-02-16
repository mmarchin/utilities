#! /usr/bin/perl
####################
# randomlines.pl - select random lines from a file given the length of file and numlines to select.
# By Madelaine Gogol
# 3/11/2008
####################


use File::Random

my ($filename,$numlines,$contents,@lines);
$filename = $ARGV[0];
$wc = $ARGV[1];
$numlines = $ARGV[2];

$contents = get_file_data($filename);

@lines = split(/\n/,$contents);

srand(time ^ $$);

for(my $i = 0; $i < $numlines; $i++)
{
	my $line = rand(@lines);
	print "$lines[$line]\n";
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
