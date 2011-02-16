#! /usr/bin/perl
####################
# smoothwigmedian.pl - take a wig file and smooth it using the median. 
# By Madelaine Marchin
# 7/2006
####################

use strict;
use DBI;
use lib "/home/mcm";
use Locations;
use POSIX;

open(OUT, ">output") or die "Can't open outfile $!";

my ($lasttrack,$filename,$dbh,$sth,$contents,@lines,$query,$chrom,$start,$end,$value,$offset,$window,$count);

$filename = $ARGV[0];
$offset = 50;
$window = 300;
$dbh = DBI->connect("DBI:mysql:host=omega;database=smoothing","$MYSQL_LOGIN","$MYSQL_PASSWORD", {RaiseError=>1});

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
		$dbh->do("alter table smoothtable add index(start)");
		$dbh->do("alter table smoothtable add index(end)");
		smoothtable($dbh,$window,$offset);

		$lasttrack = $line;
		$lasttrack =~ s/name=(\S+)/name=\1_medsmoothed/g;

		#get name of track
		$dbh->do("drop table if exists smoothtable");
		$query = "create table smoothtable (id int auto_increment,chrom varchar(20) not null, start int, end int, value float, primary key (id))";
		$dbh->do($query);
	}
	elsif($count == 0)
	{
		$lasttrack = $line;
		$lasttrack =~ s/name=(\S+)/name=\1_medsmoothed/g;
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
print "$lasttrack\n";
$dbh->do("alter table smoothtable add index(start)");
$dbh->do("alter table smoothtable add index(end)");
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
		print OUT "##### $chrom $minstart $maxend\n";
		
		my $start = $minstart;
		for($start = $minstart; $start < $maxend; $start = $start + $offset)
		{
			my @values = ();
			$end = $start + $window;
			$midpoint = ($end - $start)/2 + $start;
			$midpoint2 = $midpoint + 1;
		
			$sth2 = $dbh->prepare("select value from smoothtable where chrom = ? and start < ? and end > ? order by start");
			$sth2->execute($chrom,$end,$start);
			while(my $result2 = $sth2->fetchrow_hashref())
			{
				$value = $result2->{value};
				if($value)
				{
					#print "pushing $value\n";
					print OUT "pushing $value\n";
					push(@values,$value);	
				}
			}

			my $num = $#values + 1;
			$smoothed = median(@values);
			print OUT "$chrom\t$start\t$end\t$num values\t$smoothed\n";
			#print "median was $smoothed\n";

			if($smoothed and $#values + 1 > 0)
			{
				print "$chrom\t$midpoint\t$midpoint2\t$smoothed\n";
				print OUT "$chrom\t$midpoint\t$midpoint2\t$smoothed\n";
			}
			else
			{
				print OUT "no values or no median, moving down to next region.\n";
				my $lenvalues = $#values + 1;
				#print "moving down $chrom $start, there were $lenvalues values\n";
				#where is the next one?
				$sth3 = $dbh->prepare("select min(start) as nextstart from smoothtable where chrom = ? and start > ?");
				$sth3->execute($chrom,$end);
				if(my $result3 = $sth3->fetchrow_hashref())
				{
					$nextstart = $result3->{nextstart};
					$start = $nextstart;
					print OUT "going to next start $start\n";
					if($start == "")
					{
						print OUT "$start is blank!\n";
						$start = $maxend;
						print OUT "$start is maxend\n";
						print OUT "no next start, should go to next chrom?\n";
					}
				}
				else
				{
					$start = $maxend;
					print OUT "no next start, should go to next chrom?\n";
				}
			}
		}
	}
}


sub median
{
	my @distances = @_;
	if($#distances == 0)
	{
		return 0;
	}
	else
	{
		my (@rev_sorted,@sorted,$length,$med);
		@sorted = sort {$a <=> $b} @distances;
		@rev_sorted = sort {$b <=> $a} @distances;
		foreach my $item (@sorted)
		{
		#	print "$item\n";
		}
		foreach my $item (@rev_sorted)
		{
		#	print "$item\n";
		}
		$length = $#distances;
		$med = $sorted[$length/2];
		return $med;
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
