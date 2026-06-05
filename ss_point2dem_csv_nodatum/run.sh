#!/bin/bash

# point2dem must refuse a CSV point cloud given no datum or SRS, rather than
# silently assuming WGS84 (issue #485, PR #486, and the follow-up extending the
# guard to all CSV formats except pixel coordinates).
#
# Negative case: the run is expected to fail; we record its exit status, and
# validate.sh checks it against gold.
# Positive control: the same CSV with a datum must succeed and produce a DEM,
# which validate.sh compares against gold the usual way (gdalinfo stats).

set -x verbose
rm -rfv run
mkdir -p run

# Negative case: lon/lat/height CSV with no --datum/--csv-srs/--t_srs.
echo '10.00 20.00  5' >  run/neg.csv
echo '10.02 20.02 -3' >> run/neg.csv
echo '10.04 19.98  2' >> run/neg.csv
point2dem --csv-format '1:lon 2:lat 3:height_above_datum' --tr 500 \
  run/neg.csv -o run/neg
echo $? > run/neg_status.txt

# Positive control: same kind of CSV but with a datum. A dense small grid
# (spacing finer than --tr) gives the output DEM real coverage.
awk 'BEGIN{for(i=0;i<6;i++)for(j=0;j<6;j++)printf "%.3f %.3f 5\n",10.0+i*0.004,20.0+j*0.004}' \
  > run/pos.csv
point2dem -r earth --csv-format '1:lon 2:lat 3:height_above_datum' --tr 500 \
  run/pos.csv -o run/pos
