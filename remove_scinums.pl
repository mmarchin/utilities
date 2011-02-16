#! /usr/bin/perl
####################
# remove_scinums.pl - get rid of e
# By Madelaine Gogol 
# 10/2009
####################



while(<>)
{
	chomp;
	@stuff = split("\t");
	if($stuff[3] =~ /e/ or $stuff[1]=~/e/)
	{
		$temp = $stuff[3];
		$temp = sprintf("%.5f",$temp);
		$stuff[3] = $temp;
		$temp = $stuff[1];
		$temp = sprintf("%d",$temp);
		$stuff[1] = $temp;
	}
	$new = join("\t",@stuff);
	print "$new\n";
}

