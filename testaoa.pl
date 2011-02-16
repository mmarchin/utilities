#! /usr/bin/perl
####################
# testaoa.pl - testing array of arrays ideas 
# By Madelaine Gogol
# 4/2009
####################

use strict;
my @bin_exp;
my @input = ([1,2,3],[4,5,6],[7,8],[9,10,11,12],[13]);
# [ 1, 2, 3 ] is an anonymous array.
my @data;
my $i = 0; 
# The 'my' in the loop is imperative, otherwise, each row will erase the 
# previous one. 

for(my $k = 0; $k < 40; $k++)
{
	push @{$bin_exp[$k]}, 0;
}

${$bin_exp[5]}[0]=5;
push @{$bin_exp[5]}, 6;

print "Output loop\n"; 
foreach (@bin_exp) 
{
	print @{$_}, "\n"; 
}

#print "Explicit Output\n";
#print @{$data[0]}, "\n";
#print ${$data[0]}[0], "\n";
#print @{$data[1]}, "\n";
#print ${$data[1]}[0], "\n";
