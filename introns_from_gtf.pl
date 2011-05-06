#! /usr/bin/perl
####################
# introns_from_gtf.pl - given a sorted gtf file, create a bed file of the protein coding introns. 
# By Madelaine Gogol
# 4/2011
####################

open(FILE,$ARGV[0]);

$in_gene = 'false';

while(<FILE>)
{
	chomp;

	($chrom,$type,$exon,$start,$end,$dot,$strand,$dot,$rest) = split("\t",$_);
	($gene,$transcript) = split(";",$rest);

#	chr1  protein_coding exon  1  5662  .  -  .  gene_id = "SPAC212.11"; transcript_id = "SPAC212.11-1";
	
	if($_ =~ /.*protein_coding.*exon.*/)
	{
		$gene =~ s/gene_id = "//g;
		$gene =~ s/"$//g;
		if($gene eq $last_gene)
		{
			$count = $count + 1;
			$intron_start = $last_end+1;
			$intron_end = $start-1;
			print "$chrom\t$intron_start\t$intron_end\t$gene.$count\t1\t$strand\n";
		}
		else
		{
			$count = 0;
		}
		$last_end = $end;
		$last_gene = $gene; 
	}
}
