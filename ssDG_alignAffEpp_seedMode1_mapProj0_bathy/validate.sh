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
cat run.txt

rm -f run.txt gold.txt

echo stereo diff is $diff
if [ "$diff" != "" ]; then
    echo Stereo validation failed
    exit 1
fi

# Bathy threshold validatoin
file=run/run-threshold.txt
gold=gold/run-threshold.txt

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1
fi

diff=$(diff $file $gold)

echo bathy threshold diff is $diff
if [ "$diff" != "" ]; then
    echo Bathy threshold validation failed
    exit 1
fi

for f in run/inliers.shp run/run-mask-inliers.shp; do 
	g=${f/run\//gold\/};
	if [ ! -f "$f" ] || [ ! -f "$g" ]; then 
		echo Cannot find inlier files $f or $g. Validation failed.
		exit 1
	fi
	ans=$(cmp $f $g)
	if [ "$ans" != "" ]; then 
		echo Files $f and $g differ. Validation failed.
	    exit 1
	fi
done 

echo Validation succeded
exit 0
