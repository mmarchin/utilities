#!/usr/bin/env perl
###############################
# parse.pl 
#
# parses bowtie std err output
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
		if($_ =~ /.*reads processed: (\d+)/)
		{
			$proc = $1;
			$h{$file}{proc} = $proc;
		}
		elsif($_ =~ /.*reads with at least one reported alignment: (\d+) \(([\d\.]+)%\).*/)
		{
			$aligned = $1;
			$h{$file}{aligned} = $aligned;
			$pct = $2;
			$h{$file}{pct_aligned} = $pct;
		}
		elsif($_ =~ /.*reads that failed to align: (\d+) \(([\d\.]+)%\).*/)
		{
			$failed = $1;
			$h{$file}{failed} = $failed;
			$pct_failed = $2;
			$h{$file}{pct_failed} = $pct_failed;
		}
		elsif($_ =~ /.*reads with alignments suppressed due to -m: (\d+) \(([\d\.]+)%\).*/)
		{
			$suppressed = $1;
			$h{$file}{suppressed} = $suppressed;
			$pct_supp = $2;
			$h{$file}{pct_suppressed} = $pct_supp;
		}
	}
}

print "sample\tprocessed\taligned\tpct_aligned\tfailed\tpct_failed\tsuppressed\tpct_suppressed\n";
foreach my $f ( keys(%h))
{
	print "$f\t$h{$f}{proc}\t$h{$f}{aligned}\t$h{$f}{pct_aligned}\t$h{$f}{failed}\t$h{$f}{pct_failed}\t$h{$f}{suppressed}\t$h{$f}{pct_suppressed}\n";
}
