#! /usr/bin/perl
####################
# run fastqc, create html file with links to reports
# call with perl fastqc.pl from GERALD dir either on /n/solexa or on iparkc01 /solexa
# By Madelaine Gogol
# 11/2010
####################

use DBI;
#use SQL::Library;

#get directory names
$pwd = `pwd`;
chomp($pwd);

#make dir
`mkdir fastqc`;

#run fastqc on all sequence files in dir
#`fastqc *sequence.txt.* -Dfastqc.output_dir=fastqc`;


#get names of sequence files
$sequence_files = `ls *sequence.txt* | sed "s/ \+//g"`;
@files = split("\n",$sequence_files);

open(HTML,">fastqc/fastqc_summary.htm");

#list col names
@names = ("basic","base qual","seq qual","seq cont","base GC","seq GC","base N","len dist","seq dup","over rep","kmers");
foreach $name (@names)
{
	$name = "<td><font size=1>$name</font></td>";
}
$names = join("",@names);

#start printing table
print HTML "<table cellpadding=1><tr><td></td><td><font size=2>&nbsp;&nbsp;&nbsp;sample</font></td>$names</tr>\n";

$j = 0;
foreach $file (@files) #collecting the pass/warn/fail info for each lane.
{
	$firstpart = $file;
	$firstpart =~ s/.gz//g;
	$firstpart =~ s/.txt//g;

	#create thumbnails using imagemagick convert! How cool!
	$imagedir = "fastqc/$firstpart"."_fastqc/Images";
	`/home/mcm/utilities/thumbs.sh $imagedir`;

	open(IN,"fastqc/$firstpart"."_fastqc/summary.txt");
	@pf = ();
	$i=0;
	while(<IN>)
	{
		($passfail,$name,@junk) = split('\t',$_);
		if($passfail =~ /PASS/)
		{
			$passfail = "<td><a href=\"$firstpart"."_fastqc/fastqc_report.html#M$i\"><img border=0 src=\"$firstpart"."_fastqc/Icons/tick.png\"></a></td>";
		}
		if($passfail =~ /WARN/)
		{
			$passfail = "<td><a href=\"$firstpart"."_fastqc/fastqc_report.html#M$i\"><img border=0 src=\"$firstpart"."_fastqc/Icons/warning.png\"></a></td>";
		}
		if($passfail =~ /FAIL/)
		{
			$passfail = "<td><a href=\"$firstpart"."_fastqc/fastqc_report.html#M$i\"><img border=0 src=\"$firstpart"."_fastqc/Icons/error.png\"></a></td>";
		}
		push(@pf,$passfail);
		$i++;
	}
	$pfs = join("\t",@pf);
	
	if($file =~ /s_\d+_1_sequence.txt/ or $file =~ /s_\d+_1_sequence.txt.gz/)
	{
		#print the row (lane)
		print HTML "<tr><td><font size=2><a href=\"$firstpart"."_fastqc/fastqc_report.html\">$file</a></font></td><td nowrap>&nbsp;&nbsp;<font size=2></font>&nbsp;&nbsp;</td></td>$pfs</tr>\n";
	}
	else
	{
		print HTML "<tr><td><font size=2><a href=\"$firstpart"."_fastqc/fastqc_report.html\">$file</a></font></td><td nowrap>&nbsp;&nbsp;<font size=2></font>&nbsp;&nbsp;</td></td>$pfs</tr>\n";
		$j++;
	}
}
print HTML "</table>";
print HTML "<br>";
print HTML "<font size=2><a href=\"http://wiki/research/FastQC/SIMRreports\">How to interpret FastQC results</a></font>"; 


#another html page with actual plots (thumbnails).

#these names are slightly different, because two of the items are text based tables, not plots. Kind of messy.

@names = ("base qual","seq qual","seq cont","base GC","seq GC","base N","len dist","seq dup","kmers");
@ms = (1,2,3,4,5,6,7,8,10); #skip 0 and 9.
foreach $name (@names)
{
	$name = "<td><font size=2>$name</font></td>";
}
$names = join("",@names);

@img_files = ("per_base_quality.png","per_sequence_quality.png","per_base_sequence_content.png","per_base_gc_content.png","per_sequence_gc_content.png","per_base_n_content.png","sequence_length_distribution.png","duplication_levels.png","kmer_profiles.png");

open(HTML2,">fastqc/fastqc_plots.htm");
print HTML2 "<table cellpadding=1><tr><td></td><td><font size=2>&nbsp;&nbsp;&nbsp;sample&nbsp;&nbsp;&nbsp;</font></td>$names</tr>\n";

$j = 0;
foreach $file (@files)
{
	$firstpart = $file;
	$firstpart =~ s/.gz//g;
	$firstpart =~ s/.txt//g;
	$zipfile = "*.zip";
	`rm $zipfile`;

	@imgs = ();
	$i = 0;
	foreach $img_file (@img_files)
	{ 
		$thumb = "fastqc/$firstpart"."_fastqc/Images/thumb.".$img_file;
		$thumb2 = "$firstpart"."_fastqc/Images/thumb.".$img_file;
		if(-e "$thumb")
		{
			$image = "<td><a href=\"$firstpart"."_fastqc/fastqc_report.html#M$ms[$i]\"><img border=0 src=\"$thumb2\"></a></td>";
		}
		else
		{
			print "image doesn't exist: $thumb\n";
			$image = "<td align=\"center\"><font size=1>N/A</font></td>";
		}
		push(@imgs,$image);
		$i++;
	}
	$row = join("",@imgs);
	if($file =~ /s_\d+_1_sequence.txt/ or $file =~ /s_\d+_1_sequence.txt.gz/)
	{
		print HTML2 "<tr><td><font size=2><a href=\"$firstpart"."_fastqc/fastqc_report.html\">$file</a></font></td><td nowrap>&nbsp;&nbsp;<font size=2></font>&nbsp;&nbsp;</td></td>$row</tr>\n";
	}
	else
	{
		print HTML2 "<tr><td><font size=2><a href=\"$firstpart"."_fastqc/fastqc_report.html\">$file</a></font></td><td nowrap>&nbsp;&nbsp;<font size=2></font>&nbsp;&nbsp;</td></td>$row</tr>\n";
		$j++;
	}
}
print HTML2 "</table>";
print HTML2 "<br>";
print HTML2 "<font size=2><a href=\"http://wiki/research/FastQC/SIMRreports\">How to interpret FastQC results</a></font>"; 
