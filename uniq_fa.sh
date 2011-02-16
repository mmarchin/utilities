#!/bin/sh

#given a filename, outputs a count of the unique lines in there.

grep -o '^>.*' $1 | sort | uniq | wc -l
grep -v '^>.*' $1 | sort | uniq | wc -l
