#!/usr/bin/env perl
###############################
# parse.pl 
#
# parses bowtie2 std err output
# 3/2012
# #############################

use File::Basename;

#@files = @ARGV; 
@files = glob("*.err"); 

%h = ();

#645013 reads; of these:
#  645013 (100.00%) were paired; of these:
#    600951 (93.17%) aligned concordantly 0 times
#    38853 (6.02%) aligned concordantly exactly 1 time
#    5209 (0.81%) aligned concordantly >1 times
#    ----
#    600951 pairs aligned concordantly 0 times; of these:
#      2206 (0.37%) aligned discordantly 1 time
#    ----
#    598745 pairs aligned 0 times concordantly or discordantly; of these:
#      1197490 mates make up the pairs; of these:
#        1195247 (99.81%) aligned 0 times
#        2192 (0.18%) aligned exactly 1 time
#        51 (0.00%) aligned >1 times
#7.35% overall alignment rate


foreach my $file (@files)
{
	open(CURRENT,$file);
	while(<CURRENT>)
	{
		chomp;
		$file = basename($file);
		$file =~ s/.err//g;
		if($_ =~ /(\d+) reads; of these:/)
		{
			$proc = $1;
			$h{$file}{proc} = $proc;
		}
		elsif($_ =~ /^\s+(\d+) \(([\d\.]+)%\) aligned concordantly exactly 1 time/)
		{
			$aligned = $1;
			$h{$file}{aligned} = $aligned;
			$pct = $2;
			$h{$file}{pct_aligned} = $pct;
		}
		elsif($_ =~ /^\s+(\d+) \(([\d\.]+)%\) aligned concordantly 0 times/)
		{
			$failed = $1;
			$h{$file}{failed} = $failed;
			$pct_failed = $2;
			$h{$file}{pct_failed} = $pct_failed;
		}
		elsif($_ =~ /^\s+(\d+) \(([\d\.]+)%\) aligned concordantly >1 times/)
		{
			$multi = $1;
			$h{$file}{multi} = $multi;
			$pct_multi = $2;
			$h{$file}{pct_multi} = $pct_multi;
		}
		elsif($_ =~ /^\s+(\d+) pairs aligned 0 times concordantly or discordantly; of these:/)
		{
			$single = $1;
			$h{$file}{single} = $single;
			$h{$file}{pct_single} = $single/$proc;
		}
		elsif($_ =~ /^\s+(\d+) \(([\d\.]+)%\) aligned 0 times/)
		{
			$single_un = $1;
			$h{$file}{single_unaligned} = $single_un;
		}
		elsif($_ =~ /^\s+(\d+) \(([\d\.]+)%\) aligned exactly 1 time/)
		{
			$single_aligned_once = $1;
			$h{$file}{single_aligned_once} = $single_aligned_once;
		}
		elsif($_ =~ /^\s+(\d+) \(([\d\.]+)%\) aligned >1 times/)
		{
			$single_aligned_multi = $1;
			$h{$file}{single_aligned_multi} = $single_aligned_multi;
		}
		elsif($_ =~ /([\d\.]+)% overall alignment rate/)
		{
			$overall_pct = $1;
			$h{$file}{pct_overall} = $overall_pct;
		}
	}
	$h{$file}{total_aligned} = $h{$file}{aligned}+$h{$file}{multi} + $h{$file}{single_aligned_once} + $h{$file}{single_aligned_multi};
}

print "sample\tprocessed\taligned_once\tpct_aligned_once\tfailed\tpct_failed\taligned_multi\tpct_multi\ttotal_aligned\tsingletons\tpct_singletons\tsingletons_aligned_once\tsingletons_aligned_multi\tpct_aligned\n";
foreach my $f ( keys(%h))
{
	print "$f\t$h{$f}{proc}\t$h{$f}{aligned}\t$h{$f}{pct_aligned}\t$h{$f}{failed}\t$h{$f}{pct_failed}\t$h{$f}{multi}\t$h{$f}{pct_multi}\t$h{$f}{total_aligned}\t$h{$f}{single}\t$h{$f}{pct_single}\t$h{$f}{single_aligned_once}\t$h{$f}{single_aligned_multi}\t$h{$f}{pct_overall}\n";
}
