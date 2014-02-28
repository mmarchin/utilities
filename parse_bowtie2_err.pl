#!/usr/bin/env perl
###############################
# parse.pl 
#
# parses bowtie2 std err output
# 3/2012
# #############################

@files = glob("*.err");

%h = ();

foreach my $file (@files)
{
	open(CURRENT,$file);
	while(<CURRENT>)
	{
		chomp;
		$file =~ s/.err//g;
		if($_ =~ /(\d+) reads; of these:/)
		{
			$proc = $1;
			$h{$file}{proc} = $proc;
		}
		elsif($_ =~ /^\s+(\d+) \(([\d\.]+)%\) aligned exactly 1 time/)
		{
			$aligned = $1;
			$h{$file}{aligned} = $aligned;
			$pct = $2;
			$h{$file}{pct_aligned} = $pct;
		}
		elsif($_ =~ /^\s+(\d+) \(([\d\.]+)%\) aligned 0 times/)
		{
			$failed = $1;
			$h{$file}{failed} = $failed;
			$pct_failed = $2;
			$h{$file}{pct_failed} = $pct_failed;
		}
		elsif($_ =~ /^\s+(\d+) \(([\d\.]+)%\) aligned >1 times/)
		{
			$multi = $1;
			$h{$file}{multi} = $multi;
			$pct_multi = $2;
			$h{$file}{pct_multi} = $pct_multi;
		}
		elsif($_ =~ /([\d\.]+)% overall alignment rate/)
		{
			$overall_pct = $1;
			$h{$file}{pct_overall} = $overall_pct;
		}
	}
	$h{$file}{total_aligned} = $h{$file}{aligned}+$h{$file}{multi};
}

print "sample\tprocessed\taligned_once\tpct_aligned_once\tfailed\tpct_failed\taligned_multi\tpct_multi\ttotal_aligned\tpct_aligned\n";
foreach my $f ( keys(%h))
{
	print "$f\t$h{$f}{proc}\t$h{$f}{aligned}\t$h{$f}{pct_aligned}\t$h{$f}{failed}\t$h{$f}{pct_failed}\t$h{$f}{multi}\t$h{$f}{pct_multi}\t$h{$f}{total_aligned}\t$h{$f}{pct_overall}\n";
}
