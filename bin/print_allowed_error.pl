#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{

  # Parse a report file having the results of a set of runs, then
  # parse the output of each run. Get the maximum relative error in
  # each run. Multiply that by 1.5. That will be the allowed maxium
  # relative error in the future. for that run. Paste the resulting
  # run names and their errors in the config file for run_tests.pl,
  # for future runs.

  # This allwed relative error is only used when we don't enforce zero
  # error, that is, when the results of a run match perfectly the
  # reference.

  if ( scalar(@ARGV) < 1 ){
    print "Usage: $0 name report.txt\n";
    exit(1);
  }

  open(FILE, "<$ARGV[0]");
  my @lines = <FILE>;
  close(FILE);
  foreach my $line (@lines){
    next unless ($line =~ /^(ss.*?)\s/);
    my $dir = $1;
    my $out = "$dir/output.txt";
    if (! -e $out){
      print "Warning: no $out\n";
      next;
    }
    open(FILE, "<$out");
    my $text = join("", <FILE>);
    close(FILE);
    my $runTime = 10000;
    if ($text =~ /^.*\s([e\+\d\.\:]+?)elapsed/s){
      $runTime = $1;
    }elsif ($text =~ /^.*\s([e\+\d\.\:]+?)\s+real/s){
      $runTime = $1;
    }
    my $maxRelErr = 1e+100;
    if ($text =~ /^.*max rel err is\s+(.*?)\s/s){
      $maxRelErr = $1;
    }
    if ($maxRelErr == 0){
      $maxRelErr = 1e-10;
    }

    $maxRelErr = $maxRelErr*1.5;
    print "$dir $maxRelErr\n";
  }

}
