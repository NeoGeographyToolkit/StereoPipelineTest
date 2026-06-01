#!/bin/bash
source ../bin/setup_env.sh

file=run/run-F.tif
gold=gold/$(basename $file)

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

# Correlator mode produces a disparity but no triangulated point cloud.
if [ -e run/run-PC.tif ]; then
    echo "ERROR: run/run-PC.tif should not exist in correlator mode."
    exit 1
fi

# All per-tile subdirectories must be cleaned up after the run.
leftover=$(find run -mindepth 1 -maxdepth 1 -type d)
if [ -n "$leftover" ]; then
    echo "ERROR: leftover tile subdirectories were not cleaned up:"
    echo "$leftover"
    exit 1
fi

# Remove cached xmls
rm -fv "$file.aux.xml"
rm -fv "$gold.aux.xml"

cmp_stats.sh $file $gold
gdalinfo -stats $file | grep -v Files | grep -v -i tif > run/run.txt
gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold/run.txt

diff=$(diff run/run.txt gold/run.txt)
cat run/run.txt

rm -f run/run.txt gold/run.txt

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
