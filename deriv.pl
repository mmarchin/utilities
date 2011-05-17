#!/n/site/inst/Linux-x86_64/sys/bin/perl

# Madelaine Gogol 
# 3/2010 
# Find flat spots in a wig file, output bed track of flats, inc, dec.

use File::Basename;
use POSIX;

my ($chrom, $build, $threshold,$file,$minrun,$maxgap);

open(LOG,">deriv.log");

if (@ARGV) 
{
	($file, $minrun, $maxgap, $threshold) = @ARGV;

	print LOG "file: $file\n";
}

$shortfile = basename($file);
$shortfile =~s/\.wig//g;
print LOG "file: $file\n";

open IN, $file;
$last_chrom = "chr";
$last_start = 0;
$last_value = 0;
$last_slope = 0;
$build = 0;
while (<IN>) 
{
	$_ =~ s/[\n\r]//g;
	if ($_ =~ /^(track name=\S+)/) 
	{
		$bedline = $1."_deriv";
		print "$bedline\n";
	} 
	elsif ($_ =~ /^chr/) 
	{
		my ($chrom, $start, $end, $value) = split /\t/, $_;
		$slope = ($value - $last_value) / ($end - $last_start);
		print "$chrom\t$start\t$end\t$slope\n";
		$last_start = $end;
		$last_value = $value;
	}
}

sub samesign
{
	my ($one,$two) = @_;
	if(($one > 0 and $two > 0) or ($one < 0 and $two < 0))
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

sub median
{
        my @distances = @_;
        if($#distances == 0)
        {
                return 0;
        }
        else
        {
                my (@rev_sorted,@sorted,$length,$med);
                @sorted = sort {$a <=> $b} @distances;
                @rev_sorted = sort {$b <=> $a} @distances;
                foreach my $item (@sorted)
                {
                }
                foreach my $item (@rev_sorted)
                {
                }
                $length = $#distances;
                $med = $sorted[$length/2];
                return $med;
        }
}

