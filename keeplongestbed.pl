#! /usr/bin/perl
####################
# keeplongestbed.pl - calc lengths of bed elements, keep longest with a given name
# By Madelaine Gogol 
####################

use strict;
my ($strand,$name,%h,$contents,$score, @lines,$filename,$chrom,$start,$end);
my ($length);

$filename = $ARGV[0];

my $total = 0;
$contents = get_file_data($filename);
@lines = split('\n',$contents);

foreach my $line (@lines)
{
	($chrom,$start,$end,$name,$score,$strand) = split('\t',$line);

	$length = $end-$start;

	if(exists($h{$name}))
	{
		if($h{$name}{length} < $length)
		{
			$h{$name}{chrom} = $chrom;
			$h{$name}{start} = $start; 
			$h{$name}{end} = $end;
			$h{$name}{strand} = $strand; 
			$h{$name}{score} = $score; 
			$h{$name}{length} = $end;
		}
	}
	else
	{
		$h{$name}{chrom} = $chrom;
		$h{$name}{start} = $start; 
		$h{$name}{end} = $end;
		$h{$name}{strand} = $strand; 
		$h{$name}{score} = $score; 
		$h{$name}{length} = $end;
	}

}

foreach my $n (keys %h)
{
	print "$h{$n}{chrom}\t$h{$n}{start}\t$h{$n}{end}\t$n\t$h{$n}{score}\t$h{$n}{strand}\n";
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
