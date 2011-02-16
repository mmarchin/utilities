#! /usr/bin/perl
###########################################################
# remove_roman.pl - chrI -> chr1, etc... (line has to start with chr.)
# By Madelaine Gogol
# 8/2/2007
###########################################################

use strict;
use Roman; #roman numerals! perl is amazing.
use DBI;
use lib "/home/mcm/";
use Locations;
my ($newchrom,$contents,@lines,$junk,$gene,$probe_id,$sequence,$length,$chrom,$description);

my $contents = get_file_data($ARGV[0]);
@lines = split('\n',$contents); 
foreach my $line (@lines)
{
	#print "$line\n";
	if($line =~ /^chr(\S+).*/)
	{
		#print "\nbefore:$line\n";
		$chrom = $1;
		if(isroman($chrom)) # and $chrom != "X") #chrX / chr10! ugh. In yeast, I guess chrX is chr10, but not in other orgs.
		{
			#print "roman:$chrom\n";
			$newchrom = arabic($chrom);
			#print "$newchrom:";
		}
		else
		{
			#print "noroman:$chrom\n";
		}
		if($newchrom)
		{
			$line =~ s/chr$chrom/chr$newchrom/;
			print "$line\n";
			#print "afterchange:$line\n";
		}
		else
		{
			#print "$chrom\n";
			print "$line\n";
			#print "afternochange:$line\n";
		}
	}
	else
	{
		#line didn't start with "chrI"...
		print "$line\n";
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

####################
# subroutine revcom
# -given a DNA sequence, returns the reverse complement. Preserves capitalization.
####################
sub revcom
{
        my $sequence = $_[0];
        my $revcom = reverse($sequence); # reverse sequence
        $revcom =~ tr/ACGTRYMKWSBDHVNacgtrymkwsbdhvn/TGCAYRKMWSVHDBNtgcayrkmwsvhdbn/; # complement the reversed sequence. See wobble.tx
        return $revcom;
}
