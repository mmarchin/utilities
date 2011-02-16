#!/bin/sh

#given a filename, outputs a list of the unique variables in there.

grep -o '\$\w\+' $1 | sort | uniq -c | sort -nr | grep ' 1 ' 
grep -o '\@\w\+' $1 | sort | uniq -c | sort -nr | grep ' 1 '
grep -o '\%\w\+' $1 | sort | uniq -c | sort -nr | grep ' 1 '
