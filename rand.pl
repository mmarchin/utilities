#! /usr/bin/perl
####################
# rand.pl - select random lines from a file given the length of file and numlines to select.
# By Madelaine Gogol
# 3/11/2008
####################


rand($.) < 1 && ($line = $_) while <>;
print $line;
