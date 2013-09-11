#!/bin/bash

# Compare the stats of two images by using gdalinfo.

if [ "$#" -lt 2 ]; then echo Usage: $0 img1.tif img2.tif; exit 1; fi

img1=$1
img2=$2

# Don't put these in /tmp, as we will run this script at the same time
# for multiple data sets.
out1=tmpimg1.txt
out2=tmpimg2.txt

# Remove cached xmls
rm -fv "$img1.aux.xml"
rm -fv "$img2.aux.xml"

echo $img1 > $out1
echo $img2 > $out2

gdalinfo -stats $img1 | grep -E "Origin|STATISTICS_" | grep -v Min= | grep -v .tif | perl -pi -e 's#([=,\(\)])# $1 #g' >> $out1
gdalinfo -stats $img2 | grep -E "Origin|STATISTICS_" | grep -v Min= | grep -v .tif | perl -pi -e 's#([=,\(\)])# $1 #g' >> $out2

diff $out1 $out2
max_err.pl $out1 $out2
rm -f $out1 $out2
