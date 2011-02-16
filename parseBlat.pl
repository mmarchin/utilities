#!/usr/bin/env perl
###############################
# parseBlat.pl
#
# parses Blat result files (.psl) and outputs a format usable by ucsc browser
# 12/2005
# #############################

use Bio::SearchIO;
  
my $parser = new Bio::SearchIO(-file   => $ARGV[0], -format => 'psl');
my $check = get_file_data($ARGV[0]);

#if the file is empty, exit. Else, parse.
if($check =~ /-$/)
{
}
else
{
	$counter=0; 
	while( my $result = $parser->next_result ) 
	{
		$query_id = $result->query_name();
		if(!$result)
		{
			last;
		}
		while( my $hit = $result->next_hit)
		{
			$chromosome = $hit->name();
			while( my $hsp = $hit->next_hsp)
			{
				#while(my ($k,$v) = each %$hsp)
				#{	
				#	print "key:$k,value:$v.\n";
					#print "primary tag:$primary_tag\n";
			#	}

				$score = $hsp->score();
				$strand = $hsp->strand();
				$start = $hsp->start('hit');
				$end = $hsp->end('hit');
				$mod_score = $score*10;
				$mismatches = $hsp->mismatches();
				$length = $hsp->length();
				$strand =~ s/\-1/-/g;
				$strand =~ s/^1/+/g;
				$chromosome =~ s/omosome//g;
				if($score == 100 and $mismatches == 0)
				{
					print "$chromosome\t$start\t$end\t$query_id\t$score\t$strand\n";
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

