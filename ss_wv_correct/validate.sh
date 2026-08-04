#!/bin/bash
source ../bin/setup_env.sh

gold=gold/run.tif

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

# Remove cached xmls
rm -fv "$gold.aux.xml"

# The old-style XML and the new-style namespaced Vantor/Maxar XML run on the
# same image, so both corrected outputs must match the gold result.
for file in run/run.tif run/run_maxar_ns.tif; do

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi

    rm -fv "$file.aux.xml"

    cmp_stats.sh $file $gold
    gdalinfo -stats $file | grep -v Files | grep -v -i tif > run/run.txt
    gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold/run.txt

    diff=$(diff run/run.txt gold/run.txt)
    echo "Stats for $file:"
    cat run/run.txt

    rm -f run/run.txt gold/run.txt

    echo "diff of $file vs gold is $diff"
    if [ "$diff" != "" ]; then
        echo "Validation failed for $file"
        exit 1
    fi

done

echo Validation succeeded
exit 0
