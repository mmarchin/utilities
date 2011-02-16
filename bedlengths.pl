#! /usr/bin/perl
####################
# intersect.pl - intersectBed a number of times
# By Madelaine Gogol 
# 2/2011
####################

@filenames = @ARGV;
#first one being "control" to compare everything to.

$control = $ARGV[0];

shift(@filenames);


foreach my $file (@filenames)
{
	$intersect = `intersectBed -a $file -b $control -c | wc -l`;
	$numpeaks = `wc -l $file`;

	print "$file $control $intersect $numpeaks\n";
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
