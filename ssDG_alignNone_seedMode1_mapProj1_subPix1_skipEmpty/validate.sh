#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-DEM.tif; do 

    gold=${file/run\//gold\/}

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi

    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi

    cmp_stats.sh $file $gold
    gdalinfo -stats $file | grep -v Files | grep -v -i tif > run/run.txt
    gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold/run.txt

    diff=$(diff run/run.txt gold/run.txt)
    cat run/run.txt

    echo diff is $diff
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi
done

echo Validation succeeded
exit 0
