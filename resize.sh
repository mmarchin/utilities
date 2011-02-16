#!/bin/bash

for i in *.png
do
	j=`basename $i .png`
	convert -resize 75% "$i" resized/$j.png
done
