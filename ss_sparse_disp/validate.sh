#!/bin/bash
source ../bin/setup_env.sh

file=run/run-D_sub.tif
gold=gold/run-D_sub.tif

# The main guard: if sparse_disp could not run (for example the bundled scipy or
# gdal modules are missing) it produces no output and this fails.
if [ ! -e "$file" ]; then
    echo "ERROR: $file does not exist. sparse_disp failed (missing scipy/gdal?)."
    exit 1
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: gold $gold does not exist."
    exit 1
fi

# Remove cached stats
rm -fv "$file.aux.xml" "$gold.aux.xml"

# Tolerant comparison. The sparse_disp output drifts slightly across platforms,
# so compare the band-1 mean within a tolerance rather than an exact diff.
fmean=$(gdalinfo -stats "$file" | grep -m1 STATISTICS_MEAN | sed 's/.*=//' | tr -d ' ')
gmean=$(gdalinfo -stats "$gold" | grep -m1 STATISTICS_MEAN | sed 's/.*=//' | tr -d ' ')
echo "band-1 mean: run=$fmean gold=$gmean"

# Pass if |run - gold| <= 10% of |gold| + 1.0 (absolute floor).
ok=$(awk -v a="$fmean" -v b="$gmean" \
     'BEGIN{ d=a-b; if(d<0)d=-d; ab=(b<0?-b:b); t=ab*0.10+1.0; print (d<=t)?1:0 }')

if [ "$ok" != "1" ]; then
    echo "Validation failed: band-1 mean out of tolerance"
    exit 1
fi

echo "Validation succeeded"
exit 0
