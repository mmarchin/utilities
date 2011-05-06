#! /usr/bin/perl
####################
# average.pl - make a matrix with information on yeast genes - each gene divided into 40 sections and probe values assigned to their nearest section. 
# By Madelaine Marchin
# 7/2006
####################

use strict;
use DBI;
use lib "/home/mcm";
use Locations;
use POSIX;

my ($chromstartend,$startend,$gene,$gene_strand,$intergenic_sense,$intergenic_antisense,$sense,$antisense,$midpoint,$chrom,$start,$end,$junk,$strand,$id,$sequence,$filename, $contents, @lines);
my ($exp1,$exp2,$exp3);
my ($sth,$dbh);
my (@exp_names,$exp_name,$list,$query,@exp,$exp_values,$list2);
print "here\n";

$filename = $ARGV[0];
$dbh = DBI->connect("DBI:mysql:host=omega;database=averaging","mcm","welcome323", {RaiseError=>1});

$contents = get_file_data($filename);
@lines = split(/\n/,$contents);
($junk,@exp_names) = split(/\t/,$lines[0]);

foreach $exp_name (@exp_names)
{
	#print "$exp_name\n";
	$exp_name =~ s/\s+$//g;
	$exp_name =~ s/^\s+//g;
	$exp_name =~ s/\s/_/g;
	$exp_name =~ s/\//_/g;
	$exp_name =~ s/-/_/g;
	#print "$exp_name\n";
	$list = $list."exp_".$exp_name." float, ";
	$list2 = $list2."exp_".$exp_name.", ";
}
$list2 =~ s/, $//g;
print "$list\n";

$dbh->do("drop table if exists yeast_average_analysis_new");
$query = "create table yeast_average_analysis_new (id int auto_increment,probe_id varchar(20) not null, chrom int, start int, end int, ";
$query = $query.$list."primary key (id))";
#print "$query\n";
$dbh->do($query);

shift @lines;
foreach my $line (@lines)
{
	($chromstartend,@exp) = split(/\t/,$line);
	$id = $chromstartend;

	if($chromstartend =~ /^chr/)
	{
		($chrom,$startend) = split(/:/,$chromstartend);
		($start,$end) = split(/-/,$startend);

		$chrom =~ s/chr//g;
		$chrom =~ s/mt/17/g;

		$exp_values = join("','",@exp);
		$exp_values=~ s/,$//g;
		$exp_values=~ s/^,//g;
		$exp_values=~ s///g;
		#print ":$exp_values:\n";
		$query = "insert into yeast_average_analysis_new (probe_id,chrom,start,end,".$list2.") values ('$id','$chrom','$start','$end','".$exp_values."')";
		#print ":$query:\n";
		$sth = $dbh->do($query);
	}
}

print "Inserted yeast_average_analysis_new table into database.\n";
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
