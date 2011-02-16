#! /usr/bin/perl
###########################################################
# split_by_col.pl - given a file and column number, output into sep. files at each change in that column. 
# By Madelaine Marchin
# 9/2006 
###########################################################

use strict;
use DBI;
use lib "/home/mcm/";
use Locations;

my $contents = get_file_data($ARGV[0]);
my $column = $ARGV[1];
parse_and_save($ARGV[0],$contents,$column);

######################################################
# subroutine parse_and_save
# arguments: file contents
# purpose: parses contents and inserts into proper tables.
# returns nothing
######################################################
sub parse_and_save
{
	my ($file,$contents,$column) = @_; 
	my $current = 0;
	my $last_item = '';
        my @lines = split('\n',$contents); 
	my @temp = split("\t",$lines[0]);
	print "Splitting file $file\n";
	print " on column ".$column." of ".$lines[0]."\n which is column ".$temp[$column]."\n";
	shift(@lines);
	foreach my $line (@lines)
	{
		my @items = split(/\t/,$line);
		if($items[$column] eq $last_item)
		{
			print OUT join("\t",@items);
			print OUT "\n";
		}
		else
		{
			my $name = $items[$column];
			$name =~ s/\s/_/g;
			$name =~ s/,/_/g;
			$name =~ s/"//g;
			$name =~ s/__/_/g;
			my $filename = $file."_".$name;
			$last_item = $items[$column];
			open(OUT, ">$filename") or die "Can't open $file $!";
			print OUT join("\t",@items);
			print OUT "\n";
		}
	}
}
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
