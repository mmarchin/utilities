#! /usr/bin/perl
###########################################################
# split_bed.pl - split bed file into bedpart at each track line. 
# By Madelaine Marchin
# 9/2006 
###########################################################

my $contents = get_file_data($ARGV[0]);
my @lines = split('\n',$contents); 
my @temp = split("\t",$lines[0]);
print "Splitting bed file $ARGV[0]\n";

if($lines[0] !~/^track name/)
{
	$name = $ARGV[0];
	$name =~ s/.bed//g;
	my $filename = "bedpart_".$name;
	open(OUT, ">$filename") or die "Can't open $file $!";
}
foreach my $line (@lines)
{
	if($line =~/^track name=(\S+)/)
	{
		#new output file
		my $filename = "bedpart_".$1;
		print "opening $filename\n";
		open(OUT, ">$filename") or die "Can't open $file $!";
		print OUT "$line\n";
	}
	else
	{
		print OUT "$line\n";
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
