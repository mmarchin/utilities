#! /usr/bin/perl
####################
# uniq_gtf.pl - given a cufflinks gtf file, remove duplicate entries that are causing errors in cuffmerge. Not sure the ramifications, just trying to get cuffmerge 2.0.2 to work.
# By Madelaine Gogol
# 1/2013
####################

open(FILE,$ARGV[0]);
my $in_first_transcript = "TRUE";

open(OUT,">rejects.txt");

while(<FILE>)
{
	chomp;

	($chrom,$type,$exon,$start,$end,$dot,$strand,$dot,$rest) = split("\t",$_);
	($gene,$transcript,$fpkm,@junk) = split(";",$rest);

	#this is what I'm trying to remove -- two copies of a given gene_id with identical FPKMs, but different conf intervals. Keep first one?
	#chrXVI	Cufflinks	transcript	17423	17811	1000	.	.	gene_id "CUFF.4624"; transcript_id "CUFF.4624.1"; FPKM "3.2282099485"; frac "1.000000"; conf_lo "1.364402"; conf_hi "5.092018"; cov "3.307709";
	#chrXVI	Cufflinks	exon	17423	17811	1000	.	.	gene_id "CUFF.4624"; transcript_id "CUFF.4624.1"; exon_number "1"; FPKM "3.2282099485"; frac "1.000000"; conf_lo "1.364402"; conf_hi "5.092018"; cov "3.307709";
	#chrXVI	Cufflinks	transcript	17423	17811	1000	.	.	gene_id "CUFF.4624"; transcript_id "CUFF.4624.1"; FPKM "3.2282099485"; frac "1.000000"; conf_lo "3.228210"; conf_hi "3.228210"; cov "3.307709";
	#chrXVI	Cufflinks	exon	17423	17811	1000	.	.	gene_id "CUFF.4624"; transcript_id "CUFF.4624.1"; exon_number "1"; FPKM "3.2282099485"; frac "1.000000"; conf_lo "3.228210"; conf_hi "3.228210"; cov "3.307709";

	if($_ =~ /.*	transcript	.*/)
	{
		$transcript =~ s/ transcript_id "//g;
		$transcript =~ s/"$//g;
		#print "TX:$transcript:\n";
		if(exists($h{$transcript}))
		{
			$in_first_transcript = "FALSE";
			#don't print this either
			print OUT "$_\n";
		}
		else
		{
			$in_first_transcript = "TRUE";
			$h{$transcript} = $transcript;
			print "$_\n";
		}
	}
	elsif($_ =~ /.*	exon	.*/ and $in_first_transcript eq "FALSE")
	{
		#don't print these exons, this is for the second copy?
		print OUT "$_\n";
	}
	elsif($_ =~ /.*	exon	.*/ and $in_first_transcript eq "TRUE")
	{
		#go ahead and print this exon.
		print "$_\n";
	}
	else
	{
		print "ELSE:$_\n";
	}
}
