#! /usr/bin/perl
####################
# collapse.pl - for a genes.expr file from cufflinks... collapse genes with multiple lines into one, summing the FPKMS. 
# By Madelaine Gogol 
# 9/2010
####################

#call the script with: perl collapse.pl input_genes.expr > output_genes.expr

#for each line in the file

while(<>)
{
	if($_ =~ /^gene_id/)
	{
		print "$_";
		$in_gene = 'false';
		$last_id = '';
		$last_fpkm = 0;
		$last_fpkmlo= 0; 
		$last_fpkmhigh = 0;
	}
	else
	{
		chomp;
		($id,$bundle_id,$chrom,$start,$end,$fpkm,$fpkmlo,$fpkmhigh) = split("\t",$_);

		if($id eq $last_id)
		{
			#keep going
			$last_fpkm = $last_fpkm + $fpkm;
			$last_fpkmlo = $last_fpkmlo + $fpkmlo;
			$last_fpkmhigh = $last_fpkmhigh + $fpkmhigh;
		}
		else
		{
			if($last_id ne $id and $last_chrom)
			{
				print "$last_id\t$last_bundle\t$last_chrom\t$last_start\t$last_end\t$last_fpkm\t$last_fpkmlo\t$last_fpkmhigh\n";
				$last_fpkm = $fpkm;
				$last_fpkmlo = $fpkmlo;
				$last_fpkmhigh = $fpkmhigh;
			}
			else
			{
				#no last id? (first line)
				$last_fpkm = $fpkm;
				$last_fpkmlo = $fpkmlo;
				$last_fpkmhigh = $fpkmhigh;
			}
		}
		$last_id = $id;
		$last_bundle = $bundle_id;
		$last_chrom = $chrom;
		$last_start = $start;
		$last_end = $end;
	}
}

($id,$bundle_id,$chrom,$start,$end,$fpkm,$fpkmlo,$fpkmhigh) = split("\t",$_);
if($id eq $last_id)
{
	$last_fpkm = $last_fpkm + $fpkm;
	$last_fpkmlo = $last_fpkmlo + $fpkmlo;
	$last_fpkmhigh = $last_fpkmhigh + $fpkmhigh;
	print "$last_id\t$last_bundle\t$last_chrom\t$last_start\t$last_end\t$last_fpkm\t$last_fpkmlo\t$last_fpkmhigh\n";
}
else
{
	if($last_id ne $id and $last_chrom)
	{
		print "$last_id\t$last_bundle\t$last_chrom\t$last_start\t$last_end\t$last_fpkm\t$last_fpkmlo\t$last_fpkmhigh\n";
	}
}
