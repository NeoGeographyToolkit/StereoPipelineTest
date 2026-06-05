#!/bin/bash

# point2dem must refuse a CSV point cloud when given no datum or SRS, rather
# than silently assuming WGS84 (Earth). See issue #485, PR #486, and the
# follow-up that extends the guard to all CSV formats except pixel coordinates.
# As a positive control, the same kind of CSV with a datum (-r earth) must
# still succeed and write a DEM.

set -x verbose
rm -rfv run
mkdir -p run

# Case 1 (negative): lon/lat/height CSV, no --datum/--csv-srs/--t_srs.
# point2dem must FAIL. The guard fires before any rasterization, so the
# tiny cloud and fine grid spacing below never get used.
echo '10.00 20.00  5' >  run/neg.csv
echo '10.02 20.02 -3' >> run/neg.csv
echo '10.04 19.98  2' >> run/neg.csv
point2dem --csv-format '1:lon 2:lat 3:height_above_datum' --tr 500 \
  run/neg.csv -o run/neg > run/neg_out.txt 2>&1
echo $? > run/neg_status.txt

# Case 2 (positive control): same kind of CSV but WITH a datum.
# point2dem must SUCCEED and write run/pos-DEM.tif. Use a dense small grid
# (spacing finer than --tr) so the output has real coverage.
awk 'BEGIN{for(i=0;i<6;i++)for(j=0;j<6;j++)printf "%.3f %.3f 5\n",10.0+i*0.004,20.0+j*0.004}' \
  > run/pos.csv
point2dem -r earth --csv-format '1:lon 2:lat 3:height_above_datum' --tr 500 \
  run/pos.csv -o run/pos > run/pos_out.txt 2>&1
echo $? > run/pos_status.txt
