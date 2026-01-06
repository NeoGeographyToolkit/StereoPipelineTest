#!/bin/bash
export PATH=../bin:$PATH

for file in run/mask-bathy-plane.txt \
            run/run-mask-inliers.shp; do

    gold=gold/$(basename $file)

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi

    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi

    echo Comparing $file and $gold
    diff=$(cmp $file $gold)

    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeeded
exit 0
