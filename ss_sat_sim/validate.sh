#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-10000.map.tif \
            run/run-10001.map.tif \
            run/run-10002.map.tif \
            run/run-10003.map.tif \
            run/run-10004.map.tif; do 
    
    gold=${file/run\//gold\/}

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi
    
    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi
    
    gdalinfo -stats $file | grep -v Files | grep -v -i tif | grep -i -v size | grep -v Left | grep -v Right > run.txt
    gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v size | grep -v Left | grep -v Right > gold.txt

    diff=$(diff run.txt gold.txt |grep -E "Minimum=|Maximum=")
    rm -f run.txt gold.txt
    
    echo diff is $diff
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeded
exit 0

