#!/usr/bin/env perl
use strict;
use diagnostics;
use List::Util qw(shuffle);

sub get_done_flag{
  return "done";
}

sub get_running_flag{
  return "running";
}

sub get_not_started_flag{
  return "not_started";
}

sub get_failed_status{
  return 1; # The succesful exit status is 0.
}

sub get_curr_machine{
  my $machine = qx(uname -n);
  $machine =~ s/\s*$//g;
  $machine =~ s/\..*?$//g; # Strip the domain name if there
  return $machine;
}

sub get_status_file{
  my $baseDir = shift;
  my $runDir  = shift;
  return "$baseDir/$runDir/status.txt";
}

sub mark_all_as_not_started{

  my $baseDir    = shift;
  my $runDirs    = shift;
  my $machines   = shift;
  my $exitStatus = get_failed_status(); # initially mark as failed (1)
  my $runTime    = -1;

  # Wait until NFS sets the status correctly (the number of done runs must be 0).
  while(1){

    foreach my $runDir (@$runDirs){
      set_status( $baseDir, $runDir, get_not_started_flag(), $exitStatus, $runTime );
    }

    my $numDone = 1;
    for (my $c = 0; $c < 5; $c++){
      my (%numRunning, @notStarted);
      sleep 1;
      get_status_of_all($baseDir, $runDirs, $machines,        # inputs
                        \$numDone, \%numRunning, \@notStarted # outputs
                       );
      last if ($numDone == 0);
    }

    last if ($numDone == 0);
  }

}

sub set_status{

  my $baseDir    = shift;
  my $runDir     = shift;
  my $flag       = shift;
  my $exitStatus = shift;
  my $runTime    = shift;
  my $statusFile = get_status_file($baseDir, $runDir);

  if ( $exitStatus != "0" ){
    $exitStatus = "Fail";
  }else{
    $exitStatus = "Pass";
  }

  open(FILE, ">$statusFile");
  print FILE "$flag " . get_curr_machine() . " $exitStatus $runTime\n";
  close(FILE);

}

sub get_status{

  my $baseDir = shift;
  my $runDir  = shift;

  my ($flag, $machine, $status, $runTime) = (-1, -1, -1, -1);
  my $statusFile = get_status_file($baseDir, $runDir);

  # If we failed to read the file in the first try (perhaps NFS was slow),
  # then try again.
  for (my $attempt = 0 ; $attempt < 10 ; $attempt++){

    open(FILE, "<$statusFile") || die "File $statusFile does not exist\n";
    my $text = join("", <FILE>);
    close(FILE);
    if ($text =~ /^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)/){
      $flag    = $1;
      $machine = $2;
      $status  = $3;
      $runTime = $4;
      last;
    }else{
      print "Failed to parse the string '$text' from the file $statusFile. " .
         "Will try again soon.\n";
      sleep 5;
    }

  }

  return ($flag, $machine, $status, $runTime);
}

sub get_status_of_all {

  my ($baseDir, $runDirs, $machines,     # inputs
      $numDone, $numRunning, $notStarted # outputs
     ) = @_;

  $$numDone    = 0;
  %$numRunning = ();
  @$notStarted = ();

  sleep 1; # some delay in reading from disk since NFS can be slow
  print "\n";

  foreach my $machine (@$machines){
    $numRunning->{$machine} = 0;
  }

  foreach my $runDir (@$runDirs){

    my ($flag, $machine, $status, $runTime) = get_status($baseDir, $runDir);
    my $pad = get_max_length($runDirs) + get_max_length($machines) + 20;

    if ($flag eq get_done_flag() ){

      my $done    = "Done:         $runDir";
      my $spaces  = " " x ( $pad - length($done) );
      print $done . $spaces  . "Status: $status\n";
      $$numDone++;

    }elsif ($flag eq get_running_flag() ){
      print "Running:      $runDir on $machine\n";
      $numRunning->{$machine}++;
    }elsif ($flag eq get_not_started_flag() ){
      print "Not started:  $runDir\n";
      push(@$notStarted, $runDir);
    }else {
      print "ERROR: Unknown flag: '$flag'\n";
      exit(1);
    }

  }

  # We'd like to start the jobs in random order
  @$notStarted = shuffle(@$notStarted);
}

sub get_available_CPUs{

  # Get the list of the available CPUs. If one machine can run two
  # jobs, and none are running now, repeat that machine's name twice
  # so that two jobs can be started on it.
  my ($machines, $numCPUs, $numRunning) = @_;

  my @availableCPUs = ();

  for (my $count = 0; $count < scalar(@$machines); $count++){

    my $machine  = $machines->[$count];
    my $nCPUs    = $numCPUs->[$count];
    my $nRunning = $numRunning->{$machine};

    if ($nRunning > $nCPUs){
      print "ERROR: There are $nRunning jobs on $machine. "
         . "There should have been only $nCPUs..\n";
      #exit(1);
    }

    while ($nRunning < $nCPUs){
      push(@availableCPUs, $machine);
      $nRunning++;
      #print "Max cpus and num running: '$machine' $nCPUs $nRunning\n";
    }
  }

  return shuffle(@availableCPUs);
}

sub parse_job_file{

  my $file = shift;
  my $status = open(FILE, "<$file");
  if (!$status){
    print "Cannot open file: $file\n";
    exit(1);
  }
  my @lines = split("\n", join("", <FILE>));
  close(FILE);

  my %Settings = ();

  foreach my $setting (@lines){
    $setting =~ s/\#.*?$//g; # Wipe comments
    next unless ($setting =~ /^\s*(\w+)\s*=\s*(.*?)\s*$/);
    my $name = $1;
    my $val  = $2;
    $val =~ s/[{},\t]/ /g;
    $val =~ s/^\s*//g;
    $val =~ s/\s*$//g;

    my @vals = split(/\s+/, $val);

    if ($name eq "runDirs"){
      my @dirs = ();

      if ($vals[0] eq "all"){
        # Expand "all" into all subdirectories of given directory
        @dirs = <*>;
      }
      elsif ($vals[0] eq "cat"){

        open FILE2, "$vals[1]";
        my $lines = join("", <FILE2>);
        @dirs = split(/\n/,$lines);

        @vals = ();
        foreach my $mylines (@dirs){
          push(@vals, $mylines);
        }

      }
      else{
        # Expand "dir1 dir2/*" into "dir1 dir2/subDir1 ... dir2/subDirN"
        foreach my $val (@vals){
          @dirs = (@dirs, glob($val));
        }
      }
      @vals = ();
      foreach my $dir (@dirs){
        next unless ( -d $dir && $dir !~ /CVS$/);
        push(@vals, $dir);
      }
    }


    $Settings{$name} = \@vals;
  }

  my @runDirs       = @{ $Settings { "runDirs"    } };
  my @machines      = @{ $Settings { "machines"   } };
  my @numCPUs       = @{ $Settings { "numCPUs"    } };

  print "runDirs:  "  . join(" ", @runDirs)  . "\n";
  print "machines: "  . join(" ", @machines) . "\n";
  print "numCPUs:  "  . join(" ", @numCPUs)  . "\n";

  return (\@runDirs, \@machines, \@numCPUs);
}

sub dispatchRun{

  my $runDir     = shift;
  my $baseDir    = shift;
  my $machine    = shift;
  my $binPath    = shift;

  my $command = "ssh $machine "
     . "-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "
        . "-T -q -f '$binPath/run_one_test.pl "
           . "-baseDir $baseDir -runDir $runDir' 2>/dev/null &";
  print "$command\n";
  system($command);

}

sub get_max_length{

  my $data = shift;
  my $len  = 0;
  foreach my $val (@$data){
    my $l = length($val);
    $len = $l if ($l > $len);
  }

  return $len;
}

sub read_report{

  # read_report and write_report must be kept syncrhonized.

  my $reportFile = shift;
  my $TAT = {};

  if ( !-f $reportFile){
    return $TAT;
  }

  open(FILE, "<$reportFile");
  foreach my $line (split("\n", join("", <FILE>))){
    next unless ($line =~ /^\s*([^\s]+)\s+\d+\s+(\d+):(\d+):(\d+)/);
    $TAT->{$1} = 3600*$2 + 60*$3 + $4;
  }

  return $TAT;
}

sub write_report{

  # read_report and write_report must be kept syncrhonized.

  my $reportFile = shift;
  my $baseDir = shift;
  my $runDirs = shift;

  sleep 5; # To allow all the info to be written to files

  my $pad = get_max_length($runDirs) + 10;

  print "Writing the output to $reportFile\n";

  open(FILE_OUT, ">$baseDir/$reportFile");
  my $run  = "run";
  my $line = "Directory: $baseDir\n"
     . $run . " " x ($pad-length($run)) . "exit status   run time\n";
  print "\n" . $line;
  print FILE_OUT $line;
  foreach my $runDir (@$runDirs){
    my ($flag, $machine, $status, $runTime) = get_status($baseDir, $runDir);
    my $spaces = " " x ($pad - length($runDir));
    my $line = $runDir . $spaces  . $status . "          " . $runTime . "\n";
    print $line;
    print FILE_OUT $line;
  }
  close(FILE_OUT);
}

1;
