#!/n/site/inst/Linux-x86_64/sys/bin/perl

# Madelaine Gogol 
# 10/22/2009
# based on splitter with a simple threshold.
# Example call: perl mysplitter.pl mytrack.wig 10 300 2
# where 10 is minrun, 300 is maxgap, 2 is threshold.

use File::Basename;
use POSIX;

my ($overallthresh,$peakid,$chrom, $build, $threshold,$file,$minrun,$maxgap);



open(LOG,">mysplitter.log");

if (@ARGV) 
{
	($file, $minrun, $maxgap, $threshold, $overallthresh) = @ARGV;

	$shortfile = basename($file);
	$shortfile =~s/\.wig//g;
	print LOG "file: $file\nminrun: $minrun\nmaxgap: $maxgap\nthreshold $threshold\n";


	if($threshold =~ /pct$/)
	{
		$orig = $threshold;
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
		open(BED,">peaks_$shortfile.$minrun.$maxgap.$threshold.$orig.bed");
		print BED "track name=peaks_$shortfile.$minrun.$maxgap.$threshold.$orig useScore=1 priority=2\n";
	}
	else
	{
		open(BED,">peaks_$shortfile.$minrun.$maxgap.$threshold.bed");
		print BED "track name=peaks_$shortfile.$minrun.$maxgap.$threshold useScore=1 priority=2\n";
	}

	print LOG "file: $file\nminrun: $minrun\nmaxgap: $maxgap\nthreshold $threshold\n";
}



open IN, $file;
$last_chrom = "chr";
$build = 0;
$peakid = 1;
while (<IN>) 
{
	$_ =~ s/[\n\r]//g;
	if ($_ =~ /^(track name=\S+)/) 
	{
		#$bedline = $1."_peaks_".$minrun."_".$maxgap."_".$threshold;
		#print BED "$bedline\n";
	} 
	else
	{
		my ($chrom, $start, $end, $value) = split /\t/, $_;
		print LOG "start:$start:\n";
		print LOG "val:$value:\n";
		
		#find peaks here

		if($last_chrom eq $chrom)
		{
			if($build == 0 and $value > $threshold)
			{	
				#start a peak... keep building until you can't find any more within maxgap.
				$endpoint = $end + $maxgap;
				push(@mypeakstarts,$start);
				push(@mypeakends,$end);
				push(@mypeakvals,$value);
				print LOG "starting peak $chrom $start $value $endpoint\n";
				$build = 1;
			}
			elsif($build == 0 and $value <= $threshold)
			{
				#keep going, do nothing.
				print LOG ".";
			}
			elsif($build == 1 and $value > $threshold)
			{
				if($start < $endpoint)
				{
					#add to peak
					print LOG "adding to peak $chrom $start $value\n";
					$endpoint = $end + $maxgap;
					push(@mypeakstarts,$start);
					push(@mypeakends,$end);
					push(@mypeakvals,$value);
				}
				if($start >= $endpoint)
				{
					#finish peak and start a new peak
					if($#mypeakstarts+1 >= $minrun)
					{
						print LOG "finishing peak $last_chrom $mypeakstarts[0] $mypeakends[$#mypeakends] $peakval\n";
						$peakval = median(@mypeakvals) * 1000;
						#$peakmax = max(@mypeakvals);
						#if($peakmax > $mypeakvals[0] and $peakmax > $mypeakvals[$#mypeakends])
						#{
							#the end and start are less than the max point. (deriv was 0).
						#	$d0="TRUE";
						#}
						#else
						#{
						#	$d0="FALSE";
						#}
						#calculate
						if($peakval > $overallthresh)
						{
							print BED "$last_chrom\t$mypeakstarts[0]\t$mypeakends[$#mypeakends]\t$peakid\t$peakval\n";
							$peakid++;
						}
					}
					else
					{
						print LOG "nopeak: $#mypeakstarts+1 < $minrun\n";
					}
					print LOG "starting new peak $chrom $start $value $endpoint\n";
					@mypeakstarts = @mypeakends = @mypeakvals = ();
					$build = 1;
					$endpoint = $end + $maxgap;
					push(@mypeakstarts,$start);
					push(@mypeakends,$end);
					push(@mypeakvals,$value);
				}
			}
			elsif($build == 1 and $value <= $threshold)
			{
				if($start < $endpoint)
				{
					#keep going, add to peak, don't extend.
					print LOG "adding to peak not extending $chrom $start $value\n";
					push(@mypeakstarts,$start);
					push(@mypeakends,$end);
					push(@mypeakvals,$value);
					print LOG "_";
				}
				if($start >= $endpoint)
				{
					#finish peak, don't start a new peak.
					if($#mypeakstarts+1 >= $minrun)
					{
						print LOG "finishing peak $last_chrom $mypeakstarts[0] $mypeakends[$#mypeakends] $peakval\n";
						$peakval = median(@mypeakvals) * 1000;
						if($peakval > $overallthresh)
						{
							print BED "$last_chrom\t$mypeakstarts[0]\t$mypeakends[$#mypeakends]\t$peakid\t$peakval\n";
							$peakid++;
						}
					}
					else
					{
						print LOG "nopeak: $#mypeakstarts+1 < $minrun\n";
					}
					@mypeakstarts = @mypeakends = @mypeakvals = ();
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
			if($build == 1 and $value > $threshold)
			{
				#finish peak and start a new peak
				if($#mypeakstarts+1 >= $minrun)
				{
					$peakval = median(@mypeakvals) * 1000;
					if($peakval > $overallthresh)
					{
						print BED "$last_chrom\t$mypeakstarts[0]\t$mypeakends[$#mypeakends]\t$peakid\t$peakval\n";
						$peakid++;
					}
				}
				else
				{
					print LOG "nopeak $#mypeakstarts+1 < $minrun\n";
				}
				@mypeakstarts = @mypeakends = @mypeakvals = ();
				$build = 0;
				$endpoint = $end + $maxgap;
				push(@mypeakstarts,$start);
				push(@mypeakends,$end);
				push(@mypeakvals,$value);
			}
			elsif($build == 1 and $value <= $threshold)
			{
				#finish peak, don't start a new peak.
				if($#mypeakstarts+1 >= $minrun)
				{
					$peakval = median(@mypeakvals) * 1000;
					if($peakval > $overallthresh)
					{
						print BED "$last_chrom\t$mypeakstarts[0]\t$mypeakends[$#mypeakends]\t$peakid\t$peakval\n";
						$peakid++;
					}
				}
				else
				{
					print LOG "nopeak $#mypeakstarts+1 < $minrun\n";
				}
				@mypeakstarts = @mypeakends = @mypeakvals = ();
				$build = 0;
			}
			elsif($build == 0 and $value > $threshold)
			{	
				#start a peak... keep building until you can't find any more within maxgap.
				print LOG "starting a peak $chrom $start $end $value $endpoint\n";
				$endpoint = $end + $maxgap;
				push(@mypeakstarts,$start);
				push(@mypeakends,$end);
				push(@mypeakvals,$value);
				$build = 1;
			}
			elsif($build == 0 and $value <= $threshold)
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

