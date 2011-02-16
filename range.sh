#!/bin/bash

for minrun in {5,10,20}
{
	for maxgap in {100,200,300}
	{
		for threshold in {.5,.75,1}
		{
			perl /home/mcm/utilities/mysplitter.pl $1 $minrun $maxgap $threshold
		}
	}
}
