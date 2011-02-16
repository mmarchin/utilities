#!/bin/bash

for X in *_genes.expr
	do
	head -n 1 $X > $X.head
	tail -n +2 $X > $X.temp
	sort $X.temp > $X.sort
	perl ~/utilities/collapse.pl $X.sort > $X.temp2
	cat $X.head $X.temp2 > $X.collapse
	rm $X.sort $X.temp $X.temp2 $X.head
	done
