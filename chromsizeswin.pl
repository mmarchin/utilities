#! /usr/bin/perl
####################
# chromsizeswin.pl - given a chrom.sizes file from ucsc, create a bed file of overlapping windows. 
# By Madelaine Gogol
# 6/2010
####################



open(CHR,$ARGV[0]);
$offset = $ARGV[1];
$window = $ARGV[2];

while(<CHR>)
{
	chomp;
	($chrom,$length) = split("\t",$_);
	for(my $i = 1; $i < $length - $window; $i = $i + $offset)
	{
		$j = $i + $window;
		print "$chrom\t$i\t$j\n";
	}
}

