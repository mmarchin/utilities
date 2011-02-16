#! /usr/bin/perl
###########################################################
# lines.pl - outputs some info about line lengths. Call with name of fasta file.
# By Madelaine Marchin
# 5/2006 
###########################################################

use strict;


my @list = ("3L","3R","2R","2L");
my @list = ("chr3L","chr3R","chr2R","chr2L");

if($list[0]<$list[1])
{
	print "3L < 3R\n";	
}
else
{
	print "3R < 3L\n";
}


if($list[2]<$list[3])
{
	print "2L < 2R\n";	
}
else
{
	print "2R < 2L\n";
}


