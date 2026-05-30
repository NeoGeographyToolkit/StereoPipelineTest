#!/bin/bash
source ../bin/setup_env.sh

status=0

# 1) The Europa datum (sphere radius 1,560,800 m) must be saved into each
#    RPC file. This is the core of issue #261. Check the radius rather than
#    the full WKT, since the GEOGCS label varies with the GDAL version.
for f in run/eur_tsrs.xml run/eur_axes.xml; do
  if grep -q 'SPHEROID\[[^]]*1560800' $f; then
    echo "OK: Europa datum saved in $f"
  else
    echo "FAIL: Europa datum (1560800) missing from $f"
    status=1
  fi
done

# 2) The RPC must reproduce the input pinhole camera to better than 0.1 pixel.
for f in run/cam_test_tsrs.txt run/cam_test_axes.txt; do
  maxd=$(grep -A3 'cam1 to cam2 pixel diff' $f | grep Max | head -n1 | awk '{print $2}')
  echo "$f max pixel diff: $maxd"
  ok=$(echo "$maxd" | awk '{if ($1 != "" && $1 < 0.1) print "yes"; else print "no"}')
  if [ "$ok" != "yes" ]; then
    echo "FAIL: pixel diff too large or missing in $f"
    status=1
  fi
done

if [ $status -eq 0 ]; then
  echo "Validation succeeded"
else
  echo "Validation failed"
fi
exit $status
