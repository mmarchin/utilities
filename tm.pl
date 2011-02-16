#!/usr/bin/perl

while(<>){

	if(/^>(.*)/)
	{
		print "$1\t";
	}
	else
	{
		chop();
		$tm = &calc_tm($_);
		print "$_\t$tm\n";
	}
}

sub calc_tm {
# Usage: &calc_tm(dna_sequence).  Returns floating point number melting temperature using Operon's 
# formula.


        #my $const_na = .1;
        my $lenp;
        my $primer = $_[0];
        my $cnt_g;
        my $cnt_c;

        $cnt_g = ($primer =~ tr/G/G/);
        $cnt_c = ($primer =~ tr/C/C/);
        $lenp = length($primer);


        $tm = 81.5 - 16.6  + (41 * ($cnt_g + $cnt_c)/$lenp) - 500/$lenp;


        #print "the primer is $primer and the number of g is $cnt_g and the num of c is $cnt_c , the lenth is $lenp\n";
        return $tm;


}
