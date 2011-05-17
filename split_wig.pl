#! /usr/bin/perl
###########################################################
# split_wig.pl - split wig file at each track line. 
# By Madelaine Marchin
# 12/2010
###########################################################

my $contents = get_file_data($ARGV[0]);
my @lines = split('\n',$contents); 
my @temp = split("\t",$lines[0]);
print "Splitting wig file $ARGV[0]\n";

if($lines[0] !~ /^track name/)
{
	#my $filename = $1.".wig";
	#open(OUT, ">$filename") or die "Can't open $file $!";
	print "only one track? no track name in first line!\n";
}
foreach my $line (@lines)
{
	if($line =~/^track name=(\S+)/)
	{
		#new output file
		my $filename = $1.".wig";
		print "opening $filename\n";
		open(OUT, ">$filename") or die "Can't open $file $!";
		print OUT "$line\n";
	}
	else
	{
		if($line ne "")
		{
			print OUT "$line\n";
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
