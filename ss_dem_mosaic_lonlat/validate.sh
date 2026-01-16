#!/bin/bash
export PATH=../bin:$PATH

for i in 0 1 08 13; do
    if [ "$i" -eq 0 ]; then 
        # An test for how hole-filling works
 	file=run/run-filled.tif
    elif [ "$i" -eq 1 ]; then
        # A test for erosion
 	file=run/run-eroded.tif
    else
        # A test for individual tiles
        file=run/run-tile-${i}.tif
    fi
    
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
