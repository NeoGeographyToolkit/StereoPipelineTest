#!/bin/bash
source ../bin/setup_env.sh

gold=gold/run.tif

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi
rm -fv "$gold.aux.xml"

file=run/run.tif
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

echo Validation succeeded
exit 0
