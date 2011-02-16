#! /usr/bin/perl
####################
# remove_NA.pl - get rid of e
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

