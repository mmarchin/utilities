#!/bin/bash

#given a directory of bed files, puts u0,u1,u2 in a subdir "uniq" with u0,u1,u2 only beds.

mkdir $1/u0u1u2
for X in $1/*.bed
do
        grep U0 $X > u0 
	grep U1 $X > u1
	grep U2 $X > u2
	F=`basename $X`
	cat u0 u1 u2 > $1/u0u1u2/$F
	echo "catted to $1/u0u1u2/$F";
done

rm u0 u1 u2
