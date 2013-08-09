#!/usr/bin/perl
use strict;	   # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use Scalar::Util qw(looks_like_number);
use List::Util   qw(max min);

undef $/;          # read one whole file in one scalar

MAIN:{

  # Look at the maximum discrepancy between corresp. numbers in file1 and file2

  if (scalar(@ARGV) < 2){
    print "Usage: $0 file1 file2\n";
    exit(0);
  }

  my $file1 = shift @ARGV;
  my $file2 = shift @ARGV;
  open(FILE, "<$file1");  my @val1 = split("\n", <FILE>);  close(FILE);
  open(FILE, "<$file2");  my @val2 = split("\n", <FILE>);  close(FILE);
  if ( scalar(@val1) != scalar(@val2) ){
    print "Warning: Files $file1 and $file2 do not have the same number of rows.\n";
  }
  my $numRows = min( scalar(@val1), scalar(@val2) );

  my ($max_abs_err, $max_rel_err, $max_row, $max_col) = (0, 0, 0, 0);

  for (my $row_num = 0; $row_num < $numRows; $row_num++){

    my $row1 = $val1[$row_num];
    my $row2 = $val2[$row_num];

    # wipe all kinds of parentheses
    $row1 =~ s/[\<\>\(\)\[\]]/ /g;
    $row2 =~ s/[\<\>\(\)\[\]]/ /g;

    $row1 =~ s/^[,|\s]+//g; $row1 =~ s/[,|\s]+$//g;
    $row2 =~ s/^[,|\s]+//g; $row2 =~ s/[,|\s]+$//g;

    my @l1 = split(/[,|\s]+/, $row1);
    my @l2 = split(/[,|\s]+/, $row2);

    #foreach my $a (@l1){ print "1--$a++\n"; }
    #foreach my $a (@l2){ print "2--$a++\n"; }

    my $len1 = scalar(@l1);
    my $len2 = scalar(@l2);
    if ( $len1 != $len2 ){
      print "Warning: Row " . ($row_num + 1) . " does not have the same number "
         . "of elements in $file1 and $file2 ($len1 vs $len2).\n";
    }
    my $numlen = min( $len1, $len2 );

    my $col_num = -1;
    for (my $col = 0; $col < $numlen; $col++){

      if ( looks_like_number( $l1[$col] ) && looks_like_number( $l2[$col] ) ){

        $col_num++;

        my $err = abs( $l1[$col] - $l2[$col] );
        my $den = min(abs($l1[$col]), abs($l2[$col]));
        $den = 1 if ($den == 0);
        my $rel_err = $err/$den;
        #print "rel_err abs_err data $rel_err $err $l1[$col] $l2[$col] "
        # . "$row_num $col_num\n";
        if ($err > $max_abs_err){
          $max_abs_err = $err;
          $max_rel_err = $rel_err;
          $max_col = $col_num;
          $max_row = $row_num;
        }

        #print "$l1[$col] $l2[$col] $err\n";
        #print "Number $l1[$col]\n";

      }else{
        #print "Not number $l1[$col]\n";
      }

    }

  }

  print "Max abs err is $max_abs_err at line " . $max_row
     .                  " and column " . $max_col . " (count starts from 0)\n";
  print "At that location, max rel err is $max_rel_err\n";

  print "The corresponding lines with maximum error:\n";
  print $val1[$max_row] . "\n";
  print $val2[$max_row] . "\n";

}
