#!/usr/bin/perl
#############################################################################################
#
# op_biobin is a cornucopia of bioinformatics tools
# Sajeev Batra
# Operon Technologies
# July 26, 00
#
#############################################################################################

package op_biobin;


##############################################
#Exports the following functions:

#anneal ($dnasequence1, $dnasequence2) : returns integer score for self-dimerizing
#end_anneal ($dnasequence1, $dnasequence2) : returns integer score for hairpins
#complement_dna ($dnasequence) : returns string, complement sequence
#calc_tm ($dnasequence) : returns floating point, melting temperature using Operon's formula
#extract_oligo(left_coordinate, right_coordinate, dnasequence) : returns string.  Substring
#             starting at left_coordinate and ending at right_coordinate from dnasequenc

############################################## 






use vars qw/@ISA @EXPORT/;
require Exporter;
@ISA = 'Exporter';
@EXPORT = qw (anneal end_anneal complement_dna calc_gc_content calc_tm extract_oligo );


######################################################################################
#Functions anneal, end_anneal, complement_dna, taken from SGD Web-Primer Software 
#developed at Stanford University Genetics Department
#Modified by Sajeev Batra 3/12/00 at Operon Technologies
#Secondary structure prediction: dimers 
######################################################################################

sub extract_oligo {
# Usage: &extract_oligo(left_coordinate,right_coordinate,$sequence).  Returns sub-string starting
# from left ending at right.  Coordinates always start from 1.  Returns empty string if illegal
# coordinates are entered.

    my $leftc = $_[0], $rightc = $_[1], $originals = $_[2];

   
   

    if ($leftc > $rightc) {
	return;
    }elsif ($leftc < 1) {
	return;
    }elsif ($rightc > length($originals)) {
	$rightc = length($originals);
    }

    my $len = $rightc - $leftc + 1;
    $leftc--;
    $originals =~ /^\S{$leftc}(\S{$len})/;
   

   
    $fragment = $1;
    return ($fragment);
}

sub calc_gc_content {
    my $sequence = $_[0];
    my $len_s ;

    my $cnt_g;
    my $cnt_c;

    $sequence =~ tr/acgt/ACGT/;
    
    $cnt_g = ($sequence  =~ tr/G/G/);
    $cnt_c = ($sequence  =~ tr/C/C/);
    
    return ( ($cnt_g + $cnt_c)/length($sequence));

    
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


sub anneal {
        my $primer1;
        my $primer2;
        my $primer1c;
        my $primer2c;
        my $max_anneal_score;
        my $val1;
        my $val3;
        my $dif_length;
        $max_anneal_score = 0;
        $primer1 = $_[0];
        $primer2 = $_[1];
        $primer1c = &complement_dna($primer1);
        $primer2c = &complement_dna($primer2);
        $val1 = 0;
        $val2 = 0;
        $val1 = &anneal_part2($primer1, $primer2);
        $val2 = &anneal_part2($primer1c, $primer2c);
        if ($val1 > $val2) {$max_anneal_score = $val1;}
        else {$max_anneal_score = $val2;}
        #print OUT "max anneal is $max_anneal_score\n";
        return ($max_anneal_score);
}
sub anneal_part2 {
        my $primer;
        my $primer1;
        my $primer2;
        my $max_anneal_score;
        my $dif_length;
        $primer1 = $_[0];
        $primer2 = $_[1];
        $max_anneal_score = 0;
        $dif_length = length ($primer1) - length ($primer2);
        while ($dif_length < 0) {
                $primer1 = "N" . $primer1;
                $dif_length++;
                #print "$primer1\n";
        }
        while ($dif_length > 0) {
                $primer2 = "N" . $primer2 ;
                $dif_length--;
                #print "$primer2\n";
        }
        #print "$primer1\n";
        #print "$primer2\n";
        while ($primer2) {
                my $p1;
                my $t1;
                my $anneal_score;
                my $temp_anneal;
                $p1 = $primer1;
                $t1 = $primer2;
                $anneal_score = 0;
                $temp_anneal = 0;
                while ($t1) {
                        my $val1;
                        my $val2;
                        my $length;
                        $val1 = substr ($t1, 0, 1);
                        $length = length ($t1);
                        $t1 = substr ($t1, 1, ($length - 1));
                        #print "$t1, $val1\n";
                        $val2 = chop ($p1);
                        #print "$val2, $val1";
                        #$temp_anneal = 0;
                        if (($val1 eq "C" && $val2 eq "G") || ($val2 eq "C" && $val1 eq "G")) {
                                $temp_anneal = $temp_anneal +4;
                        }
                        elsif (($val1 eq "A" && $val2 eq "T") || ($val2 eq "A" && $val1 eq "T")) {
                                $temp_anneal = $temp_anneal +2;
                        }
                        else {
                                if ($temp_anneal > $anneal_score) {
                                        $anneal_score = $temp_anneal;
                                        $temp_anneal = 0;
                                }
                        }
                        #print "$anneal_score\n";
                }
                #print "Anneal score is $anneal_score\n";
                if ($temp_anneal > $anneal_score) {
                        $anneal_score = $temp_anneal;
                }
                if ($anneal_score > $max_anneal_score) {
                        $max_anneal_score = $anneal_score;
                }
                my $temp_length;
                $temp_length = length ($primer2);
                $primer2 = substr($primer2,1,($temp_length-1));
        }
        #print OUT "max anneal is $max_anneal_score\n";
        return ($max_anneal_score);
}


sub complement_dna {
        my $block;
        my $i;
        my @block;
        my $comp_block;
        $block = $_[0];
        #print "comp $block\n";
        $i = 0;
        $block =~ tr/AGCTagct/TCGAtcga/;
        while ($block) {
                $block[$i] = chop $block;
                $i++;
        }
        $comp_block = join ("", @block);
        #print "OK $comp_block\n\n";
        return $comp_block;
}

sub end_anneal {
        my $primer1;
        my $primer1c;
        my $primer2;
        my $primer2c;
        my $val1;
        my $val2;
        my $end_max_anneal_score;
        $end_max_anneal_score = 0;
        $val1 = 0;
        $val2 = 0;
        $primer1 = $_[0];
        $primer2 = $_[1];
        $primer1c = &complement_dna($primer1);
        $primer2c = &complement_dna($primer2);
        $val1 = &end_anneal_part2($primer1, $primer2);
        $val2 = &end_anneal_part2($primer1c, $primer2c);
        if ($val1 >$val2) {$end_max_anneal_score = $val1;}
        else {$end_max_anneal_score = $val2;}
        return ($end_max_anneal_score);

}
sub end_anneal_part2 {
        my $primer1;
        my $primer2;
        my $test_primer;
        my $end_max_anneal_score;
        $end_max_anneal_score = 0;
        $primer1 = $_[0];
        $primer2 = $_[1];
        $dif_length = length ($primer1) - length ($primer2);
        while ($dif_length < 0) {
                $primer1 = "N" . $primer1;
                $dif_length++;
                #print "$primer1\n";
        }
        while ($dif_length > 0) {
                $primer2 = "N" . $primer2 ;
                $dif_length--;
                #print "$primer2\n";
        }
        while ($primer2) {
                my $p1;
                my $t1;
                my $anneal_score;
                my $begin;
                $p1 = $primer1;
                $t1 = $primer2;
                $anneal_score = 0;
                $begin = 1;
                while ($t1) {
                        my $val1;
                        my $val2;
                        $val1 = substr ($t1, 0, 1);
                        $length = length ($t1);
                        $t1 = substr ($t1, 1, ($length - 1));
                        $val2 = chop ($p1);
                        #print "$val1, $val2, $begin";
                        if (($val1 eq "C" && $val2 eq "G") || ($val2 eq "C" && $val1 eq "G")) {
                                $anneal_score = $anneal_score +4;
                                #print "$anneal_score";
                                if ($begin) {
                                        if ($anneal_score > $end_max_anneal_score) {
                                                $end_max_anneal_score = $anneal_score;
                                        }
                                }
                        }
                        elsif (($val1 eq "A" && $val2 eq "T") || ($val2 eq "A" && $val1 eq "T")) {
                                $anneal_score = $anneal_score +2;
                                if ($begin) {
                                        if ($anneal_score > $end_max_anneal_score) {
                                                $end_max_anneal_score = $anneal_score;
                                        }
                                }
                        }
                        else {
  $begin = 0;
                                $anneal_score = 0;
                                #print "\n";
                                #last;
                        }
                        #print " $anneal_score\n";
                }
                #print "end\n";
                if ($anneal_score > $end_max_anneal_score) {
                        $end_max_anneal_score = $anneal_score;
                }
                my $temp_length;
                $temp_length = length ($primer2);
                $primer2 = substr($primer2, 1, ($temp_length - 1));
        }
        #print "end max anneal is $end_max_anneal_score\n";
        return ($end_max_anneal_score);
}










