#!/usr/bin/perl
# convert splitter output
# to BED file format
# Chris Seidel, August 2009
# Mod by Madelaine Gogol 10/2009

print "track name=$ARGV[0]\n"; 

open(SP,$ARGV[1]);
while (<SP>)
{
    # skip header comments
    next if(/^\#/);
    ($position, $signal, $length) = split(/\t/);

    $position =~ /(\w+):(\d+)-(\d+)/;
    $chr = $1;
    $start = $2;
    $end = $3;
    print join("\t", ($chr, $start, $end, $signal)), "\n";
}

