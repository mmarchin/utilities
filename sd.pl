#! /usr/bin/perl
#
use strict;

my @ar = (2,3,4,6,7);
my $sd = sd(@ar);
my $mean = mean(@ar);
my $sum = sum(@ar);
print "$sum\t$mean\t$sd";


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

sub sd
{
	my $sum_of_squares = 0;
	my @nums = @_;
	my $mean = mean(@nums);
	my $n = scalar(@nums);
	for(my $i = 0; $i < $n; $i++)
	{
		print "$i\t$nums[$i]\n";
		$sum_of_squares = $sum_of_squares + ($nums[$i] - $mean)**2;
	}
	print "$sum_of_squares\n";
	$sd = sqrt($sum_of_squares/($n-1));
	print "$sd\n";
	return($sd);
}
