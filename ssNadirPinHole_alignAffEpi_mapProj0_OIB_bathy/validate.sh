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

# Also validate the interest point matches extracted from the disparity with
# --num-matches-from-disparity. These exercise the crop-window code path (the
# matches are shifted from the cropped domain to full-image coordinates). The
# match file is deterministic, so compare it directly.
mfile=run/run-disp-img_icebridge2__img_icebridge3.txt
mgold=gold/$(basename $mfile)

if [ ! -e "$mfile" ]; then
    echo "ERROR: File $mfile does not exist."
    exit 1;
fi

if [ ! -e "$mgold" ]; then
    echo "ERROR: File $mgold does not exist."
    exit 1;
fi

mdiff=$(diff $mfile $mgold)
echo match diff is $mdiff
if [ "$mdiff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
