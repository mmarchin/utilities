#!/usr/bin/env perl
###############################
# parseBlast.pl
#
# parses Blast result files (-m 8, tabular) and outputs top scoring hit for each query? 
# 4/2012
# #############################

use strict;
use warnings;
use Bio::SearchIO;
my $searchio = new Bio::SearchIO(-file => $ARGV[0], -format => "blasttable") or die "Blast file parsing failed.";

my %h = ();

while(my $result = $searchio->next_result) 
{
	while(my $subject = $result->next_hit) 
	{
		while(my $hsp = $subject->next_hsp)
		{
			my @output = ($subject->name, $hsp->length, $hsp->bits, $hsp->evalue);
			#print "output:@output\n";

			if(exists($h{$result->query_name}))
			{
			}
			else
			{
				$h{$result->query_name} = [ @output ];
			}
		}
	}
}

my @k = keys(%h);
print "keys:@k\n"; 
for my $item (keys %h)
{
	my @ar = @{ $h{$item} };
	print $item."\t",join("\t",@ar),"\n";
}
