#!/usr/bin/env perl
use strict;
use diagnostics;
use Cwd;
use File::Spec;

# Run one test. This script is launched by run_tests.pl.
# README.txt has more details.

MAIN:{

  if (scalar(@ARGV) < 6){
    print "Usage: $0 -baseDir <baseDir> -runDir <runDir> -configFile <configFile>\n";
    exit(1);
  }

  my $baseDir    = $ARGV[1]; # Save here the status of each test and the summary
  my $runDir     = $ARGV[3]; # Here will run the curent test
  my $configFile = $ARGV[5]; # The configuration file

  my $binPath = bin_path();

  my $exitStatus =  get_failed_status(); # Start as failed
  my $runTime    = -1;

  if ( -d $baseDir){
    chdir $baseDir;
  }else{
    print "ERROR: $baseDir does not exist\n";
    set_status( $baseDir, $runDir, get_done_flag(), $exitStatus, $runTime );
    exit(1);
  }

  # Parse the job file and set environmental variables
  my ($runDirs, $machines, $numProc, $strictValidation) = parse_job_file($configFile);

  # Job is running
  set_status( $baseDir, $runDir, get_running_flag(), $exitStatus, $runTime );

  if ( -d $runDir){
    chdir $runDir;
  }else{
    print "ERROR: Directory $runDir does not exist\n";
    set_status( $baseDir, $runDir, get_done_flag(), $exitStatus, $runTime );
    exit(1);
  }

  # The script which will decide if the run passed or failed
  my $validate = "./validate.sh";
  if ( (!-e $validate) || (!-x $validate) ){
    print "ERROR: Script $validate does not exist or is not executable.\n";
    set_status( $baseDir, $runDir, get_done_flag(), $exitStatus, $runTime );
    exit(1);
  }

  my $outfile = "output.txt";
  my $prog = '/usr/bin/time ./run.sh';

  # Do the run. Extract the exist status and the running time.
  qx(uname -a        >  $outfile 2>&1);
  qx(env             >> $outfile 2>&1);
  qx(rm -rfv ./run   >> $outfile 2>&1);
  qx($prog           >> $outfile 2>&1);
  qx($validate       >> $outfile 2>&1);
  $exitStatus = ($? >> 8);
  if (!-e $outfile){
    $exitStatus = get_failed_status();
  }else{
    open(OFILE, "<$outfile"); my $data = join("", <OFILE>); close(OFILE);
    if ($data =~ /^.* ([^\s]*?)elapsed/s){
      $runTime = $1;
    }elsif ($data =~ /^.*\s([^\s]*?)\s+real/s){
      $runTime = $1;
    }

    # Allow small errors when comparing the current run to the reference
    # if the user chooses so.
    my $maxRelErr = 1e+100;
    if ($data =~ /^.*max rel err is\s+(.*?)\s/s){
      $maxRelErr = $1;
    }
    if ($strictValidation eq "0" && $maxRelErr < 1e-5){
      $exitStatus = get_success_status();
    }
  }

  # Job finished
  set_status( $baseDir, $runDir, get_done_flag(), $exitStatus, $runTime );
}


sub bin_path{

  # Instruct the script to get its dependencies from the same location
  # where the script itself resides.

  my $binPath = File::Spec->rel2abs( __FILE__ );
  $binPath =~ s!^(.*)/.*$!$1!g;

  push(@INC, $binPath);
  require 'test_utils.pl';

  return $binPath;
}
