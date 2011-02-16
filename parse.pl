#!/usr/bin/env perl
###############################
# parse.pl 
#
# parses InParanoid file for Hua
# 1/2011
# #############################

$next = 0;
while(<>)
{
	if($_ =~ /^Score/)
	{
		$next = 1;
	}
	elsif($next == 1 and $_ =~/^CE/)
	{
		$line = $_;
		chomp($line);
		@items = split("[\t ]+",$line);
		$newline = join("\t",@items);
		print "$newline\n";
		$next = 0;
	}
	else
	{
		$next = 0;	
	}
}
