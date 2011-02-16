#!/usr/local/bin/perl
#
# Usage: rename perlexpr [files]

if (!@ARGV) {
   @ARGV = <STDIN>;
   chomp(@ARGV);
}


foreach $_ (@ARGV) 
{
   	$old_name = $_;
	$new_name = reverse($old_name);
	print "$new_name\n";
}
