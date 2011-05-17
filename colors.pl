#! /usr/bin/perl
#
# fiddling with color displays... either in the terminal or html.

$red = "\e[1;31m";
$green = "\e[0;32m"; 
$magenta = "\e[0;35m"; 
$aqua = "\e[0;36m"; 

$normal = "\e[0m\n";

#print "$red This $aqua is $magenta pretty! $normal\n";

print "<font color=\"#FF0000\">red</font><font color=\"#00FFFF\">aqua</font>\n";



