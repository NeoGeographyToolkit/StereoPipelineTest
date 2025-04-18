#!/bin/bash
export PATH=../bin:$PATH

for file in run/aligned_image2.tif run/run-transform.txt run/run-ecef-transform.txt; do
    
    gold=${file/run\/run/gold\/run}

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi
    
    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi
    
    cmp $file $gold
    ans="$?"
    
    if [ "$ans" != "0" ]; then
        echo Validation failed
        exit 1
    fi
done

echo Validation succeeded
exit 0

