#!/bin/bash
export PATH=../bin:$PATH

file=run/run-DEM.tif
gold=gold/run-DEM.tif

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

# Remove cached xmls
rm -fv "$file.aux.xml"
rm -fv "$gold.aux.xml"

cmp_stats.sh $file $gold
gdalinfo -stats $file | grep -v Files | grep -v -i tif > run.txt
gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold.txt

diff=$(diff run.txt gold.txt)
rm -f run.txt gold.txt

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

# Test shp and qml files produced by parallel_stereo
for file in run/run-tiles.shp run/run-tiles.qml; do 
    gold=gold/$(basename $file)
    # Use cmp to test these. It should hopefully fail if a file does not exist as well.
    echo Comparing $file to $gold
    cmp $file $gold
    ans="$?"
    if [ "$ans" != "0" ]; then
        echo Validation failed comparing $file to $gold
        exit 1
    fi
done

echo Validation succeeded
exit 0
