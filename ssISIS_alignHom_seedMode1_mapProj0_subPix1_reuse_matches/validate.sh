#!/bin/bash
export PATH=../bin:$PATH

for file in run/ba1/run-M0100115.adjust run/ba1/run-E0201461.adjust; do 
	 gold=${file/run\//gold\/}

    if [ ! -e "$file" ] || [ ! -f "$gold" ]; then
        echo "ERROR: Either $file or $gold does not exist."
        exit 1;
    fi
done

for file in run/run-L.tif; do 
    
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
    gdalinfo -stats $file | grep -v Files | grep -v -i tif | grep -i -v size | grep -v Left | grep -v Right > run.txt
    gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v size | grep -v Left | grep -v Right > gold.txt

    diff run.txt gold.txt

    max_err.pl run.txt gold.txt # print the error
    ans=$(max_err.pl run.txt gold.txt 1e-5) # compare the error
    if [ "$ans" -eq 0 ]; then
        echo Validation failed
        exit 1
    fi
    
    rm -f run.txt gold.txt
    
    echo diff is $diff
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeeded
exit 0
