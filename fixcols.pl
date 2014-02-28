#! /usr/bin/perl
####################
# fixcols.pl - given wig type file fix start > end
# By Madelaine Gogol 
# 4/29/2008
####################



while(<>)
{
	chomp;
	if(/^track/)
	{
		print "$_\n";
	}
	else
	{
		@stuff = split("\t");
		if($stuff[1] > $stuff[2])
		{
			$temp = $stuff[1];
			$temp2 = $stuff[2];
			$stuff[1] = $temp2;
			$stuff[2] = $temp;
		}
		$new = join("\t",@stuff);
		print "$new\n";
	}
}

