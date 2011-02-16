#! /usr/bin/perl
####################
# flatten_ragged.pl - for a file like id tab thing1 space thing2 space ... flatten so there's one id per line and one "thing" per line. 
# By Madelaine Gogol 
# 12/2009
####################

#call the script with: perl flatten_ragged.pl < input.txt > output.txt

#for each line in the file
while(<>)
{
	#remove the end of line character
	chomp;
	($id,@things) = split(" ",$_);
	#print "$id\n";
	foreach $mything (@things)
	{
		print "$id\t$mything\n";
	}
}

