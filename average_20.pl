#! /usr/bin/perl
####################
# average_20.pl - make a matrix with information on yeast genes - each gene divided into 6 sections, 2 up, 2 dn and probe values assigned to their nearest section. No linear interpolation.
# By Madelaine Gogol 
# 6/2008
####################

#use strict;
use DBI;
use lib "/home/mcm";
use Locations;
#use POSIX;

$file = $ARGV[0];
$choice = $ARGV[1];

$dbh = DBI->connect("DBI:mysql:host=omega;database=averaging","mcm","welcome323", {RaiseError=>1});
$dbh2 = DBI->connect("DBI:mysql:host=omega;database=yeast","mcm","welcome323", {RaiseError=>1});

open(OUT, ">$file") or die "Can't open $file $!";

$sth0 = $dbh->prepare("show columns from yeast_average_analysis_new like ?");
$sth0->execute("exp_%");
while(my @result0 = $sth0->fetchrow_array())
{
	push(@experiments,$result0[0]);	
}
for(my $i = 0; $i <= $#experiments; $i++)
{
#	print "$i: $experiments[$i]\n";
}

#print "Which experiment would you like to generate a gene average matrix for? (0,1,2,etc): ";
#$choice = <STDIN>;

$experiment = $experiments[$choice];
print "Generating a matrix for $experiment...\n";

$sth = $dbh2->prepare("select * from yeast_genes_2010 order by chrom,start");
$sth->execute();
while(my $result = $sth->fetchrow_hashref())
{
	#initialize the bins
	@bin_exp=();

	#print "resetting bins";
	for(my $k = 0; $k < 20; $k++)
	{
		push @{$bin_exp[$k]}, 0;
	}
	
	#get gene info
	$chrom = $result->{chrom};
	$start = $result->{start};
	$end = $result->{end};
	$strand = $result->{strand};
	$gene = $result->{sys_id};
	$description = $result->{description};
	$alias = $result->{alias};
	
	#print "$chrom $start $end $strand $gene\n";

	#figure out gene bins
	$gene_length = $end - $start + 1;
	$width_of_bins = ($gene_length/14);
	
	my $i = 0;
	$gene_bins[0] = $start - 480;
	$gene_bins[1] = $start - 320;
	$gene_bins[2] = $start - 160;

	for($i = 0 ; $i < 14; $i++)
	{
		$gene_bins[$i+3] = $start + $i*$width_of_bins;# + ($width_of_bins/2);
		#	print "in gene, bins: $gene_bins[$i+4]\n";
	}
	$gene_bins[17] = $end + 160;
	$gene_bins[18] = $end + 320;
	$gene_bins[19] = $end + 480;

	#get probes for gene region
	$sth2 = $dbh->prepare("select * from yeast_average_analysis_new where chrom = ? and (start + ((end-start)/2)) >= ? and (start + ((end-start)/2)) <= ?");
	my $one = $gene_bins[0];
	my $two = $gene_bins[19];
	$sth2->execute($chrom,$one,$two);
	while(my $result2 = $sth2->fetchrow_hashref())
	{
		$probe_id = $result2->{probe_id};
		$exp = $result2->{"$experiment"};
		$probe_start = $result2->{start};
		$probe_end = $result2->{end};
		$probe_midpoint = ($probe_end-$probe_start)/2 + $probe_start;
		#print "probe $probe_id\t$exp\t$probe_start\t$probe_end\t$probe_midpoint\n";
	
		#figure out which bin is closest to probe_midpoint
		$closest = 1000000000;
		$closest_bin = -1;
		for(my $j = 0; $j <= $#gene_bins; $j++)
		{
			if(abs($probe_midpoint - $gene_bins[$j]) < $closest)
			{
				$closest = abs($probe_midpoint - $gene_bins[$j]);
				$closest_bin = $j;
			}
		}
		if(${$bin_exp[$closest_bin]}[0] == 0)
		{
			${$bin_exp[$closest_bin]}[0] = $exp;
		}
		else
		{
			push @{$bin_exp[$closest_bin]},$exp;
		}
	}

	#print output
	print OUT "$gene\t";
	#print "$gene\t";
	if($strand eq 'W')
	{
		#print output - genes
		for(my $k = 0; $k <= $#gene_bins; $k++)
		{
			my $mn = mean(@{$bin_exp[$k]});
			print OUT "$mn\t";
		}
	}
	else
	{
		#print output - genes
		for(my $k = 0; $k <= $#gene_bins; $k++)
		{
			my $mn = mean(@{$bin_exp[$#gene_bins - $k]});
			print OUT "$mn\t"; #make sure we print 5' to 3' end
		}
	}
	print OUT "\n";
}

print "Results in $file.\n";

sub mean
{
	my $mean;
	my @nums = @_;
	$mean = sum(@nums)/scalar(@nums);
	return($mean);
}

sub sum
{
	my $total;
	my @nums = @_;
	($total+=$_) for @nums;
	return $total;
}

