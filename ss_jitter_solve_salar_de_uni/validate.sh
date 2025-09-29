#!/bin/bash
export PATH=../bin:$PATH

# Validate the produced cameras
for file in \
    run/run-csm-104001001427B900.r100.adjusted_state.json \
    run/run-csm-1040010014761800.r100.adjusted_state.json; do
    
    gold=gold/$(basename $file)
    
    # file must exist
    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi
    
    # gold must exist
    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi

    # Diff must be empty
    diff=$(diff $file $gold)
    if [ "$diff" != "" ]; then
        echo Validation failed for $file
        exit 1
    else
        echo Validation succeeded for $file
    fi
done

# Validate the orbit_plot.py results
file=run/run.png
gold=gold/run.png

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
gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold/gold.txt

diff=$(diff run/run.txt gold/gold.txt)
cat run/run.txt

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded for $file
exit 0
