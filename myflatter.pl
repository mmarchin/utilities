#!/n/site/inst/Linux-x86_64/sys/bin/perl

# Madelaine Gogol 
# 10/22/2009
# based on splitter with a simple threshold.
# Example call: perl myflatter.pl mytrack.wig 10 300 2
# where 10 is minrun, 300 is maxgap, 2 is threshold.

use File::Basename;
use POSIX;

my ($chrom, $build, $threshold,$file,$minrun,$maxgap);

open(LOG,">myflatter.log");

if (@ARGV) 
{
	($file, $minrun, $maxgap, $threshold) = @ARGV;

	if($threshold =~ /pct$/)
	{

		$threshold =~ s/pct//g;
		$wc = `wc -l $file`;
		$wc =~ s/\s.*//g;
		$line = floor($wc * $threshold / 100);
		print LOG "line should be $line wc:$wc pct:$threshold\n";
		`cut -f 4 $file | sort -n > $file.sort`;
		$cmd = "sed -n ".$line."p $file.sort";
		$result = `$cmd`;
		chomp $result;
		$result =~ s/^0//g;
		print LOG "threshold calced:$result:\n";
		$threshold = sprintf("%.2f",$result);
		`rm $file.sort`;
	}

	print LOG "file: $file\nminrun: $minrun\nmaxgap: $maxgap\nthreshold $threshold\n";
}

$shortfile = basename($file);
$shortfile =~s/\.wig//g;
print LOG "file: $file\nminrun: $minrun\nmaxgap: $maxgap\nthreshold $threshold\n";

open(BED,">flats_$shortfile.$minrun.$maxgap.$threshold.bed");

open IN, $file;
$last_chrom = "chr";
$build = 0;
while (<IN>) 
{
	$_ =~ s/[\n\r]//g;
	if ($_ =~ /^(track name=\S+)/) 
	{
		$bedline = $1."_flats_".$minrun."_".$maxgap."_".$threshold;
		print BED "$bedline\n";
	} 
	elsif ($_ =~ /^chr/) 
	{
		my ($chrom, $start, $end, $value) = split /\t/, $_;
		print LOG "start:$start:\n";
		print LOG "val:$value:\n";
		
		#find flats here

		if($last_chrom eq $chrom)
		{
			if($build == 0 and $value <= $threshold)
			{	
				#start a flat... keep building until you can't find any more within maxgap.
				$endpoint = $end + $maxgap;
				push(@myflatstarts,$start);
				push(@myflatends,$end);
				push(@myflatvals,$value);
				print LOG "starting flat $chrom $start $value $endpoint\n";
				$build = 1;
			}
			elsif($build == 0 and $value > $threshold)
			{
				#keep going, do nothing.
				print LOG ".";
			}
			elsif($build == 1 and $value <= $threshold)
			{
				if($start < $endpoint)
				{
					#add to flat
					print LOG "adding to flat $chrom $start $value\n";
					$endpoint = $end + $maxgap;
					push(@myflatstarts,$start);
					push(@myflatends,$end);
					push(@myflatvals,$value);
				}
				if($start >= $endpoint)
				{
					#finish flat and start a new flat
					if($#myflatstarts+1 >= $minrun)
					{
						print LOG "finishing flat $last_chrom $myflatstarts[0] $myflatends[$#myflatends] $flatval\n";
						$flatval = median(@myflatvals);
						#$flatmax = max(@myflatvals);
						#if($flatmax > $myflatvals[0] and $flatmax > $myflatvals[$#myflatends])
						#{
							#the end and start are less than the max point. (deriv was 0).
						#	$d0="TRUE";
						#}
						#else
						#{
						#	$d0="FALSE";
						#}
						#calculate
						print BED "$last_chrom\t$myflatstarts[0]\t$myflatends[$#myflatends]\t$flatval\n";
					}
					else
					{
						print LOG "noflat: $#myflatstarts+1 < $minrun\n";
					}
					print LOG "starting new flat $chrom $start $value $endpoint\n";
					@myflatstarts = @myflatends = @myflatvals = ();
					$build = 1;
					$endpoint = $end + $maxgap;
					push(@myflatstarts,$start);
					push(@myflatends,$end);
					push(@myflatvals,$value);
				}
			}
			elsif($build == 1 and $value > $threshold)
			{
				if($start < $endpoint)
				{
					#keep going, add to flat, don't extend.
					print LOG "adding to flat not extending $chrom $start $value\n";
					push(@myflatstarts,$start);
					push(@myflatends,$end);
					push(@myflatvals,$value);
					print LOG "_";
				}
				if($start >= $endpoint)
				{
					#finish flat, don't start a new flat.
					if($#myflatstarts+1 >= $minrun)
					{
						print LOG "finishing flat $last_chrom $myflatstarts[0] $myflatends[$#myflatends] $flatval\n";
						$flatval = median(@myflatvals);
						print BED "$last_chrom\t$myflatstarts[0]\t$myflatends[$#myflatends]\t$flatval\n";
					}
					else
					{
						print LOG "noflat: $#myflatstarts+1 < $minrun\n";
					}
					@myflatstarts = @myflatends = @myflatvals = ();
					$build = 0;
				}
			}
			else
			{
				print LOG "here1\n";
			}
		}
		else #new chromosome.
		{
			if($build == 1 and $value <= $threshold)
			{
				#finish flat and start a new flat
				if($#myflatstarts+1 >= $minrun)
				{
					$flatval = median(@myflatvals);
					print BED "$last_chrom\t$myflatstarts[0]\t$myflatends[$#myflatends]\t$flatval\n";
				}
				else
				{
					print LOG "noflat $#myflatstarts+1 < $minrun\n";
				}
				@myflatstarts = @myflatends = @myflatvals = ();
				$build = 0;
				$endpoint = $end + $maxgap;
				push(@myflatstarts,$start);
				push(@myflatends,$end);
				push(@myflatvals,$value);
			}
			elsif($build == 1 and $value > $threshold)
			{
				#finish flat, don't start a new flat.
				if($#myflatstarts+1 >= $minrun)
				{
					$flatval = median(@myflatvals);
					print BED "$last_chrom\t$myflatstarts[0]\t$myflatends[$#myflatends]\t$flatval\n";
				}
				else
				{
					print LOG "noflat $#myflatstarts+1 < $minrun\n";
				}
				@myflatstarts = @myflatends = @myflatvals = ();
				$build = 0;
			}
			elsif($build == 0 and $value <= $threshold)
			{	
				#start a flat... keep building until you can't find any more within maxgap.
				print LOG "starting a flat $chrom $start $end $value $endpoint\n";
				$endpoint = $end + $maxgap;
				push(@myflatstarts,$start);
				push(@myflatends,$end);
				push(@myflatvals,$value);
				$build = 1;
			}
			elsif($build == 0 and $value > $threshold)
			{
				print LOG "x";
				#keep going, do nothing.
			}
			else
			{
				print LOG "here\n";
			}
		}
		$last_chrom = $chrom
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

