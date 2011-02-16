#! /usr/bin/perl
####################
# makerandom.pl - given length and number generates that many random sequences 
# By Madelaine Gogol 
# 6/2007
####################

use strict;

my ($length,$amount,$range,$minimum);
$length = $ARGV[0];
$amount = $ARGV[1];
$range = 4;
$minimum = 1;

for(my $i = 1; $i <= $amount; $i++)
{
	print ">random".$i."\n";
		
	for(my $j = 0; $j < $length; $j++)
	{
		my $random = int(rand($range)) + $minimum;
		if($random == 1)
		{
			print "A";
		}
		elsif($random ==2)
		{
			print "C";
		}
		elsif($random == 3)
		{
			print "G";
		}
		elsif($random == 4)
		{
			print "T";
		}
		else
		{
			print "\nError - $random\n";
		}
	}
	print "\n"
}

