#! /usr/bin/perl
####################
# fakeid.pl - given file append a fake id of the 2-5th columns
# By Madelaine Gogol 
# 10/2009
####################


while(<>)
{
	chomp;
	@stuff = split("\t");
	$fake_id = join("_",$stuff[1],$stuff[2],$stuff[3],$stuff[4]);
	$new = join("\t",@stuff,$fake_id);
	print "$new\n";
}

