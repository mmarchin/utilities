#! /usr/bin/perl
####################
# translate_ids.pl - given a file with a col of ids and one with two cols of ids, translate one to the other.. 
# By Madelaine Gogol 
# 12/2009
####################

#call the script with: perl translate_ids.pl dictionary.txt file_to_translate.txt

#for each line in the file
$dictionary = $ARGV[0];
open(TRANS,$ARGV[1]);
$col = $ARGV[2];
while(<TRANS>)
{
	#remove the end of line character
	chomp;
	($id,@rest) = split("\t",$_);

	$resultline = `grep $id $dictionary | head -n 1`;	
	chomp($resultline);
	#print "$id res:$resultline\n";
	(@results) = split("\t",$resultline);
	
	print "$results[$col-1]".join("\t",@rest)."\n";
}

