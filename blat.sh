#!/bin/sh

# takes fasta file, genome, blats fasta entries, parses the result, puts into ucsc browser format 

gfClient genekc01 17778 -maxIntron=0 -minScore=0 -minIdentity=0 $2 $1 $1.psl

perl ~/utilities/parseBlat.pl $1.psl > $1.bed

sort +0d -1 +1n -2 $1.bed | uniq > $1.uniq.bed
