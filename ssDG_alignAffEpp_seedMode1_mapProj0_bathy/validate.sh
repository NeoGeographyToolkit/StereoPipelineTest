#!/bin/bash

export PATH=../bin:$PATH

for file in run/run-DEM.tif; do

    gold=gold/$(basename $file)
    
    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1
    fi
    
    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
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
    
    echo stereo diff is $diff
    if [ "$diff" != "" ]; then
        echo Stereo validation failed
        exit 1
    fi
done

# Bathy threshold validatoin
file=run/run-threshold.txt
gold=gold/$(basename $file)

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1
fi

diff=$(diff $file $gold | head -n 50)

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

echo Validation succeeded
exit 0
