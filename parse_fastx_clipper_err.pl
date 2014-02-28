#!/usr/bin/env perl
###############################
# parse.pl 
#
# parses bowtie2 std err output
# 3/2012
# #############################

@files = glob("*.fastx_clipper.err");

%h = ();

foreach my $file (@files)
{
	open(CURRENT,$file);
	while(<CURRENT>)
	{
		chomp;
		$file =~ s/.fastx_clipper.err//g;
		if($_ =~ /Input: (\d+) reads./)
		{
			$input = $1;
			$h{$file}{input} = $input;
		}
		elsif($_ =~ /Output: (\d+) reads./)
		{
			$output = $1;
			$h{$file}{output} = $output;
		}
		elsif($_ =~ /discarded (\d+) too-short reads./)
		{
			$too_short = $1;
			$h{$file}{too_short} = $too_short;
		}
		elsif($_ =~ /discarded (\d+) adapter-only reads./)
		{
			$adapter = $1;
			$h{$file}{adapter} = $adapter;
		}
		elsif($_ =~ /discarded (\d+) non-clipped reads./)
		{
			$nonclipped = $1;
			$h{$file}{nonclipped} = $nonclipped;
		}
	}
}

print "sample\tinput\toutput\ttoo_short\tadapter\tnonclipped\n";
foreach my $f ( keys(%h))
{
	print "$f\t$h{$f}{input}\t$h{$f}{output}\t$h{$f}{too_short}\t$h{$f}{adapter}\t$h{$f}{nonclipped}\n";
}
