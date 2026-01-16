#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-c1.tif run/reload/run-run-c1.tif; do
    
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
    gdalinfo -stats $file | grep -v Files | grep -v -i tif | grep -i -v size | grep -v Left | grep -v Right > run/run.txt
    gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v size | grep -v Left | grep -v Right > gold/run.txt

    diff=$(diff run/run.txt gold/run.txt |grep -E "Minimum=|Maximum=")
    rm -f run/run.txt gold/run.txt
    
    echo diff is $diff
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi

done

for file in run/jitter/run-final_residuals_stats.txt; do
    
    gold=gold/$(basename $file)
    echo Comparing $file and $gold
    diff=$(diff $file $gold)
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi
done

echo Validation succeeded
exit 0

