#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-DEM.tif run/run-L-R-disp-diff.tif; do 
    
    gold=${file/run\//gold\/}
    
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
    
    echo diff is $diff
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi
done

echo Validation succeeded
exit 0
