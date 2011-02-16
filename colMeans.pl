#! /usr/bin/perl
####################
# colMeans.pl - for a file like id tab gene tab value1 tab value2... collapse genes with multiple probes (lines) into one, averaging the values. 
# By Madelaine Gogol for Vikki Weake 
# 12/2009
####################

#call the script with: perl colMeans.pl input.txt > output.txt

#for each line in the file
$in_gene = 'false';
$last_fbgn = '';

while(<>)
{
	if($_ =~ /^FBgn ID/)
	{
	}
	else
	{
		chomp;
		#remove the end of line character
		($fbgn,$gene_symbol,@probe_values) = split("\t",$_);

		if($fbgn eq $last_fbgn)
		{
			#keep going
			print "keep going...\n";
			#push @AoA, [@probe_values];
			@AoA = @probe_values;
			$last_fbgn = $fbgn;
			$last_symbol = $gene_symbol;
		}
		else
		{
			#new gene, average last one.
			if($last_fbgn)
			{
				#print "avg last one\n";
				print "$last_fbgn\t$last_symbol\t";
				colMeans(\@AoA);
				@AoA = ();
			#	push @AoA, [@probe_values];
				@AoA = $probe_values;
				$last_fbgn = $fbgn;
				$last_symbol = $gene_symbol;
			}
			else
			{
			#	push @AoA, [@probe_values];
				@AoA = @probe_values;
				$last_fbgn = $fbgn;
				$last_symbol = $gene_symbol;
			}
		}
	}
}

#average the columns


sub colMeans
{
	my $arrayref = @_;
	
	print "[1][1]:$arrayref->[1][1]\n";

}


sub mean
{
        my $mean;
        my @nums = @_;
        $mean = sum(@nums)/scalar(@nums);
        return($mean);
}



