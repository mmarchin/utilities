#!/usr/bin/perl

# read in the sequence
@seq = ();
while($line = <>){
    next if(/^>/);
    push(@seq,$line);
}
$seq = join("", @seq);
$seq =~ s/[^GCATagct]//g;
$length = length($seq);
#print $seq, "\n";
    $skip = 0;
    while($skip < $length-70){
       $region = substr($seq,$skip,70);
#       print $region, "\t";
       print calc_tm($region), "\n";
       $skip += 1;
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
