#!/usr/bin/perl
# modified from CWS's gal_fix.pl script.
#
# Usage: $0 infile > outfile
use strict;

my(@fields,$numfields,@list,$l_len);

$_ = <>; #get the first row, which contains header/fields pair
print $_;
s/[\r\n]//g; # get rid of end of line chars before splitting
@fields = split(/\t/);
$numfields = $#fields+1;
#print "$numfields\n";

while(<>){
    @list = split(/\t/);
    $l_len = @list;
    if( $l_len < $numfields ){
	s/(\s+)$//;
	print $_;
	for(my $i=$l_len;$i<$numfields;++$i){
	    print "\t";
	}
	print "\n";
    }
    else{
	print $_;
    }
}

