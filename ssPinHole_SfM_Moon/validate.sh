#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-DEM.tif; do

    gold=gold/$(basename $file)
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
    gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold/run.txt

    # Theia uses --random_seed=1 for reproducibility, but minor
    # floating-point variation remains from the Ceres/MKL solver.
    ../bin/max_err.pl run/run.txt gold/run.txt # print the error
    ans=$(../bin/max_err.pl run/run.txt gold/run.txt 1e-2) # compare the error
    if [ "$ans" != "1" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeeded
exit 0
