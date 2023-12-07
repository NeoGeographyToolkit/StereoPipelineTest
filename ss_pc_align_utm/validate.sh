#!/bin/bash
export PATH=../bin:$PATH

file=run/run-trans_reference.tif
gold=gold/run-trans_reference.tif

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

diff=$(diff run.txt gold.txt | head -n 50)
cat run.txt

rm -f run.txt gold.txt

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

file=run/run-trans_source.csv
gold=gold/run-trans_source.csv

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

diff=$(diff $file $gold | head -n 50)
echo "diff is $diff"
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

# Add validation for pdal
pdal info run/run-trans_reference.las  | grep -v filename | grep -v now > run/pdal_run.txt
pdal info gold/run-trans_reference.las | grep -v filename |grep -v now > gold/pdal_gold.txt

diff=$(diff run/pdal_run.txt gold/pdal_gold.txt | head -n 50)
echo "diff is $diff"
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeded
exit 0

