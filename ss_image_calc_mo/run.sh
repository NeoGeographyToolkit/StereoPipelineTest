#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# Test GDAL-style --mo metadata. A value is everything after the first equal
# sign, so it may contain spaces and further equal signs. The option can be
# repeated, with one VAR=VALUE pair each time, or hold several pairs in one
# quoted string (backward compatible).
image_calc -o run/output.tif -d float32 -c "var_0" ../data/dem1_10pct.tif \
  --mo 'VAR1=val1 VAR2=val2' \
  --mo 'VAR3=value with spaces' \
  --mo 'VAR4=a = b'
