samtools rmdup -s accepted_hits.sorted.bam accepted_hits.rmdup.bam
bamToBed -i accepted_hits.rmdup.bam | sed "s/^/chr/g" > accepted_hits.rmdup.bed
coverageBed -a accepted_hits.rmdup.bed -b Mus_musculus.NCBIM37.52.bed | sort -r -n -k7 > counts_unique.txt
