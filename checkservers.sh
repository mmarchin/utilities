#! /usr/bin/env bash

#from stackoverflow.com/questions/1911144

minLoad=1
for h in $(cat ~/listofservers.txt); do
	load=`ssh mcm@$h uptime`
	echo "$h $load";
done
