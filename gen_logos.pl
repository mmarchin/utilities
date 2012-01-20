#! /usr/bin/perl
####################
# gen_logos.pl - given a file with motifs from cisfinder, generate logos and create an html doc
# By Madelaine Gogol 
# 12/2011
####################

use strict;
my $motif_file = $ARGV[0];

my $file = get_file_data($motif_file);
my @lines = split("\n",$file);

print "<html>\n";
print "<body>\n";
`mkdir gif`;

my $i = 0;
foreach my $line (@lines)
{
	if($line =~ /^>/)
	{
		my ($name,$pat,$revpat,$freq,$ratio,$info,$score,$pval,$fdr,$pal,$nmem,$method,$motifname) = split(" ",$line);
		$name =~ s/^>//g;
		`motiflogo $motif_file gif/$i.gif -num $i`;
		$i++;
		print "<p>$name<br>$pat<br>score=$score<br>pval=$pval<br>fdr=$fdr<br><img src=\"gif/$i.gif\"><br>&nbsp;<br>&nbsp;<br>\n";
	}
}
print "</body></html>";

######################################################
# subroutine get_file_data
# arguments: filename
# purpose: gets data from file given filename;
# returns file contents
######################################################

sub get_file_data
{
        my($filename) = @_;

        my @filedata = ();

        unless( open(GET_FILE_DATA, $filename))
        {
                print STDERR "Cannot open file \"$filename\": $!\n\n";
                exit;
        }
        @filedata = <GET_FILE_DATA>;
        close GET_FILE_DATA;
        return join('',@filedata);
}

