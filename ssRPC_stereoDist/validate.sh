#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-DEM.tif; do

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
    gdalinfo -stats $file | grep -v Files | grep -v -i tif | grep -i -v size | grep -v Left | grep -v Right > run/run.txt
    gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v size | grep -v Left | grep -v Right > gold/run.txt

    diff run/run.txt gold/run.txt

    max_err.pl run/run.txt gold/run.txt # print the error
    ans=$(max_err.pl run/run.txt gold/run.txt 1e-5) # compare the error
    if [ "$ans" -eq 0 ]; then
        echo Validation failed
        exit 1
    fi

    rm -f run/run.txt gold/run.txt

    echo diff is $diff
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeeded
exit 0
