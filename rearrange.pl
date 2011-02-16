#! /usr/bin/perl
####################
# rearrange.pl - given a tab delim text file and list of columns, rearrange columns in order. 
# By Madelaine Gogol
# 6/2010
####################



open(FILE,$ARGV[0]);
@columns = @ARGV;
shift(@columns);

while(<FILE>)
{
	chomp;
	(@items) = split("\t",$_);
	@newcol = ();
	foreach my $col (@columns)
	{
		push(@newcol,$items[$col-1]);
	}
	print join("\t",@newcol),"\n";
}

