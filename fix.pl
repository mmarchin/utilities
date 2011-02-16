#! /usr/bin/perl
####################
# fix.pl
# By Madelaine Gogol 
# 9/2010
####################

#for each line in the file

$count = 1;
$in_match = 'false';
while(<>)
{
	chomp;
	#print "$_\n";
	($id,$num,@junk) = split("_",$_);
	
	if($id eq $last_id)
	{
		if($num eq $last_num)
		{
			$count++;
			#print "$_\n";
			$in_match = 'true';
		}	
		else
		{
			if($in_match eq 'true')
			{
				print "$last_line\t$count\n";
				$count = 1;
				$in_match = 'false';
			}
			else
			{
				$count = 1;
				$in_match = 'false';
			}
		}
	}
	else #id is not last id
	{
		#check if 
		if($in_match eq 'true')
		{
			print "$last_line\t$count\n";
			$count = 1;
			$in_match = 'false';
		}
		else
		{
			$count = 1;
			$in_match = 'false';
		}
	}

	$last_id = $id;
	$last_num = $num;
	$last_line = $_;
	
}
