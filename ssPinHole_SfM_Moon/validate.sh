#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-DEM.tif; do

    gold=${file/run\//gold\/};
    echo $file $gold
    
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
    
    ../bin/cmp_stats.sh $file $gold
    gdalinfo -stats $file | grep -v Files | grep -v -i tif > run/run.txt
    gdalinfo -stats $gold | grep -v Files | grep -v -i tif > run/gold.txt

    # Do not make the error small, because Theia is not deterministic
    ../bin/max_err.pl run/run.txt run/gold.txt # print the error
    ans=$(../bin/max_err.pl run/run.txt gold/run.txt 1e-2) # compare the error
    if [ "$ans" != "1" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeded
exit 0
