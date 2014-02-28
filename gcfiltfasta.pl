#! /usr/bin/perl
####################
# gcfiltfasta.pl - given fasta format file and length and gc range, keep fasta entries in range.
# uses Bioperl
# By Madelaine Gogol
# 9/2013
####################

use strict;
use Bio::SeqIO;

my ($defline,$sequence,$count,$in,$elements_to_print,$gcpct);

my $length = $ARGV[1];
my $gclo = $ARGV[2];
my $gchi = $ARGV[3];

my $justright=0;
my $gchigh=0;
my $gclo=0;
my $short=0;

open(gchigh,">$ARGV[0].gchigh.fa");
open(short,">$ARGV[0].short.fa");
open(justright,">$ARGV[0].filt.fa");

$in = Bio::SeqIO->new(-file=>"$ARGV[0]", -format=>'Fasta');
while(my $seq = $in->next_seq())
{
	$sequence = $seq->seq();
	$defline = $seq->display_id();

	if(length($sequence) > $length) 
	{
		#print ">$defline\n$sequence\n";
		$gcpct = calcgc($sequence);
		if($gcpct > $gclo and $gcpct < $gchi)
		{
			print justright ">$defline:",length($sequence),":$gcpct\n$sequence\n";
			$justright++;
		}
		elsif ($gcpct >= $gchi )
		{
			print gchigh ">$defline\n$sequence\n";
			$gchigh++;
		}
		else
		{
			$gclo++;
		}
	}
	else
	{
		print short ">$defline.".length($sequence)."\n$sequence\n";
		$short++;
	}
}
print "justright:$justright\tgchigh:$gchigh\tgclo:$gclo\tshort:$short\n";

######################################################    
# subroutine get_file_data
# arguments: filename
# purpose: gets data from file given filename;
# returns file contents
######################################################

sub calcgc {
	my $seq = $_[0];
	my $count = 0;
	$count++ while ($seq =~ m/[GC]/gi);
	my $num = $count / length($seq);;
	my ($dec) = $num =~ /(\S{0,6})/;
	return $dec;
}

