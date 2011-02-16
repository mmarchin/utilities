#! /usr/bin/perl
####################
# smoothwig.pl - smooth a wig file. 
# By Madelaine Marchin
# 7/2006
####################

use strict;
use DBI;
use lib "/home/mcm";
use Locations;
use POSIX;

my ($lasttrack,$filename,$dbh,$sth,$contents,@lines,$query,$chrom,$start,$end,$value,$offset,$window,$count);

$filename = $ARGV[0];
$offset = 500;
$window = 1000;
$dbh = DBI->connect("DBI:mysql:host=omega;database=averaging","$MYSQL_LOGIN","$MYSQL_PASSWORD", {RaiseError=>1});

$contents = get_file_data($filename);
@lines = split(/\n/,$contents);
$count = 0;

foreach my $line (@lines)
{
	#print "$count\n";
	if($line =~ /^track/ and $count > 0)
	{
		#output last smoothtable data before moving on...
		print "$lasttrack\n";
		smoothtable($dbh,$window,$offset);

		$lasttrack = $line;
		$lasttrack =~ s/name=(\S+)/name=\1_smoothed/g;

		#get name of track
		$dbh->do("drop table if exists smoothtable");
		$query = "create table smoothtable (id int auto_increment,chrom varchar(20) not null, start int, end int, value float, primary key (id))";
		$dbh->do($query);
	}
	elsif($count == 0)
	{
		$lasttrack = $line;
		$lasttrack =~ s/name=(\S+)/name=\1_smoothed/g;
		$dbh->do("drop table if exists smoothtable");
		$query = "create table smoothtable (id int auto_increment,chrom varchar(20) not null, start int, end int, value float, primary key (id))";
		$dbh->do($query);
	}
	else
	{	
		($chrom,$start,$end,$value) = split(/\t/,$line);
	
		if($chrom ne "")
		{
			$query = "insert into smoothtable (chrom,start,end,value) values ('$chrom','$start','$end','$value')";
			$sth = $dbh->do($query);
		}
	}
	$count++;
}

#print "loaded data into table, creating indexes\n";

$dbh->do("create index start on smoothtable (start)");
$dbh->do("create index end on smoothtable (end)");
$dbh->do("create index chrom on smoothtable (chrom)");

#print "indexes created\n";

print "$lasttrack\n";

smoothtable($dbh,$window,$offset);


sub smoothtable
{
	my ($midpoint,$midpoint2,$sth,$dbh,$sth2,$chrom,$minstart,$maxend,$start,$end,$smoothed,$nextstart,$sth3);
	my($dbh,$window,$offset) = @_;
	#smoothtable (chrom,start,end,value)
	#for each chrom, loop through with window, print out results. no overlaps.
	#print "here\n";
	
	$sth = $dbh->prepare("select chrom,min(start) as minstart,max(end) as maxend from smoothtable group by chrom");
	$sth->execute();
	while(my $result = $sth->fetchrow_hashref())
	{
		$chrom = $result->{chrom};
		$minstart = $result->{minstart};
		$maxend = $result->{maxend};	
		
		for($start = $minstart; $start < $maxend; $start = $start + $offset)
		{
			$end = $start + $window;
			$midpoint = ($end - $start)/2 + $start;
			$midpoint2 = $midpoint + 1;
		
			#print "select avg(value) as smoothed from smoothtable where chrom = $chrom and start <= $end and end >= $start\n";
			$sth2 = $dbh->prepare("select avg(value) as smoothed from smoothtable where chrom = ? and start <= ? and end >= ?");
			$sth2->execute($chrom,$end,$start);
			if(my $result2 = $sth2->fetchrow_hashref())
			{
				$smoothed = $result2->{smoothed};
				
				if($smoothed)
				{
					print "$chrom\t$midpoint\t$midpoint2\t$smoothed\n";
				}
				else
				{
					#print "moving down $chrom $start\n";
					#where is the next one?
					$sth3 = $dbh->prepare("select min(start) as nextstart from smoothtable where chrom = ? and start > ?");
					$sth3->execute($chrom,$start);
					if(my $result3 = $sth3->fetchrow_hashref())
					{
						$nextstart = $result3->{nextstart};
						#print "next start is $nextstart\n";
						$start = $nextstart - $offset;
					}
				}
			}
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
