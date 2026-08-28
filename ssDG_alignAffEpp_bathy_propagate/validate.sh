#!/bin/bash

source ../bin/setup_env.sh

for file in run/run-DEM.tif run/run-HorizontalStdDev.tif run/run-VerticalStdDev.tif; do
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
done
