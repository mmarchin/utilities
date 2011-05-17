#! /usr/bin/perl
####################
# remove_NA.pl - get rid of NA lines
# By Madelaine Gogol 
# 10/2009
####################



while(<>)
{
	chomp;
	if($_ =~ /.*NA.*/)
	{
	}
	else
	{
		print "$_\n";
	}
}

