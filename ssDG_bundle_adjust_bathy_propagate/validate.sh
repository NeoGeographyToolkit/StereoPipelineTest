#!/bin/bash
source ../bin/setup_env.sh

# Compare the propagated triangulation uncertainties (horizontal and vertical
# medians, means, stddevs, and the sample count) to the gold, with a relative
# tolerance. With bathymetry the vertical stddev is large (bimodal land/water),
# which is the signature this test guards. The image-path columns are skipped.
f=run/ba-triangulation_uncertainty.txt
g=gold/ba-triangulation_uncertainty.txt

if [ ! -e "$f" ]; then echo "ERROR: File $f does not exist."; exit 1; fi
if [ ! -e "$g" ]; then echo "ERROR: File $g does not exist."; exit 1; fi

awk '
  FNR==NR { if ($0 !~ /^#/) { for (i=3; i<=9; i++) gold[i]=$i } ; next }
  $0 !~ /^#/ {
    for (i=3; i<=9; i++) {
      d=$i-gold[i]; if (d<0) d=-d;
      ref=(gold[i]<0?-gold[i]:gold[i]); tol=0.02*ref; if (tol<0.01) tol=0.01;
      if (d>tol) { printf "Field %d: run=%s gold=%s tol=%g FAIL\n", i,$i,gold[i],tol; bad=1 }
      else       { printf "Field %d: run=%s gold=%s OK\n", i,$i,gold[i] }
    }
  }
  END { if (bad) { print "Validation failed"; exit 1 } print "Validation succeeded"; exit 0 }
' $g $f
exit $?
