#!/bin/bash
source ../bin/setup_env.sh

# Validate the cross-projection GeoPackage. Both images are local stereographic
# (metric); the source center is shifted 0.1 deg from the reference. The writer
# must use the reference CRS for the layer and reproject the source match coords
# into it, so dx/dy come out near zero (in meters). Without the reprojection,
# dx would be ~8.8e3 m (the center shift). No gold file is needed.

gpkg=run/matches.gpkg
if [ ! -e "$gpkg" ]; then echo "ERROR: $gpkg missing"; exit 1; fi

rm -fv run/matches.csv
ogr2ogr -f CSV run/matches.csv "$gpkg"

# dx, dy (reference meters) must be small. Working: a few pixels at 50 m. Broken
# (no reprojection): ~8.8e3 m. Threshold 1000 m separates them cleanly.
maxabs=$(awk -F, '
  NR==1{ for(i=1;i<=NF;i++){ g=$i; gsub(/"/,"",g); if(g=="dx")dxc=i; if(g=="dy")dyc=i } next }
  dxc&&dyc{ x=$dxc+0; if(x<0)x=-x; y=$dyc+0; if(y<0)y=-y; if(x>m)m=x; if(y>m)m=y }
  END{ if(!dxc||!dyc) print "NA"; else printf "%.3f", m }' run/matches.csv)
echo "max |dx|,|dy| = $maxabs meters"

ok=$(awk -v m="$maxabs" 'BEGIN{ print (m!="NA" && m+0<1000)?1:0 }')
if [ "$ok" -ne 1 ]; then
  echo "Validation failed: dx/dy not near zero (reprojection likely wrong)."
  exit 1
fi

echo "Validation succeeded"
exit 0
