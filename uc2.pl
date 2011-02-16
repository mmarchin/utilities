#! /usr/bin/perl
####################
# lc.pl - given file make sixth col lowercase 
# uses Bioperl
# By Madelaine Gogol 
# 4/29/2008
####################



while(<>)
{
	chomp;
	@stuff = split("\t");
	$stuff[5] = lc($stuff[5]);
	$new = join("\t",@stuff);
	print "$new\n";
}

