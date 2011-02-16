#!/usr/bin/perl
# Program to convert eland export format to BED format
# for running MACS
# Chris Seidel, June 2009
#
# Requires tab delim file of chromosome or contig names 
# (eland fa match files) in the format:
# UCSC_chr_name chr_length eland_name
# corrects for alignments that go off the ends of the chrs
# negative bases are trimmed to 1, 
# bases > chr_length are set to chr_length
# (I know the former exist, I don't know if the latter exist)
# results are not sorted, but can be sorted in linux by:
# sort -o infile.bed -k 1,1 -k 2,2n infile.bed
# (sort in place, first column, then by second column numeric)

die("usage: $0 chrmap.txt eland_export.txt") unless(scalar(@ARGV) == 2);

# create output filename
$outfile = $ARGV[1];
$outfile =~ s/\.txt$/\.bed/;
open(FOUT, ">$outfile") || die("can't open output file: $outfile");

# get info on chromosomes
open(cmap, $ARGV[0]) || die("no chromosome name mapping file!");
%chrmap = {};
while($line = <cmap>){
    chomp($line);
    ($newval, $size, $oldval) = split(/\t/, $line);
    $chrmap{$oldval} = $newval;
    $chrsize{$oldval} = $size;
}

# open input file
open(fp, $ARGV[1]) || die("can't open eland file");

$lines = 0;
while(<fp>){
    chop;
    ++$lines;
    @bits = split(/\t/);
    # skip reads that didn't pass filtering
    next if($bits[21] eq "N");
    # get match name
    $seqname = $bits[10];
    # skip No Matches or QC failures
    # next if($seqname =~ /NM|QC/);
    # skip repeat matches
    # next if($seqname =~ /\d+:\d+:\d+/);
    # we're only interested in sequences that match our chrs
    next unless(exists($chrmap{$seqname}));

    $seqlen = length($bits[8]);
    $start = $bits[12];
    $end = $start + $seqlen - 1;
    $strand = $bits[13];

    # parse match descriptor
    $n = ($bits[14] =~ tr/[ACGTN]/[ACGTN]/);
    # skip reads beyond a certain threshold
    next if($n > 2);
    $read_code = "U".$n;

    # correct for alignments off the chromosome ends
    if( $start <= 0 ){
	print STDERR "start less than or equal to 0:   ", $start, "\n";
	print STDERR join("\t", @bits), "\n";
	$start = 1;
    }

    if($end > $chrsize{$seqname}){
	print STDERR "end greater than chr end $chrsize{$seqname}:   $end, diff: ", $end - $chrsize{$seqname}, "\n";
	print STDERR join("\t", @bits), "\n";
	$end = $chrsize{$seqname};
    }

    if($strand eq "F"){
	$strand = "+";
	$color = "0,0,255";
    }
    else{
	$strand = "-";
	$color = "255,0,0";
    }

    $score = 0;
    print FOUT join("\t", $chrmap{$seqname}, $start, $end, $read_code, $score, $strand, $start, $end, $color), "\n";

    # give some feedback
    print STDERR "$lines processed\n" if(!($lines % 100000));
}

close(FOUT);
print STDERR "output file: $outfile\n";
