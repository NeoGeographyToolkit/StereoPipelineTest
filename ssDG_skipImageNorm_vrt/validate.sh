#!/bin/bash
source ../bin/setup_env.sh

file=run/run-DEM.tif
gold=gold/$(basename $file)

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

# The skip-image-normalization VRT working images must stay VRTs. If
# parallel_stereo materialized them to TIFF, that would copy pixels, which
# this feature is meant to avoid.
for img in run/run-L.tif run/run-R.tif; do
    if [ ! -e "$img" ]; then
        echo "ERROR: File $img does not exist."
        exit 1;
    fi
    driver=$(gdalinfo "$img" | grep "^Driver:")
    if ! echo "$driver" | grep -q "VRT"; then
        echo "Validation failed: $img was materialized, not a VRT ($driver)"
        exit 1
    fi
    echo "$img stayed a VRT ($driver)"
done

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
