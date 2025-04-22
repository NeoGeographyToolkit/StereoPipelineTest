#!/bin/bash
export PATH=../bin:$PATH

file=run/run-RPC.tif
gold=gold/run-RPC.tif

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

gdalinfo -stats $file | grep -v Files | grep -v -i tif | grep -i -v -E min | grep -i -v max > run.txt
gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v -E min | grep -i -v max > gold.txt

diff=$(diff run.txt gold.txt | head -n 50)
#cat run.txt
#echo Diff is $diff

../bin/max_err.pl run.txt gold.txt
ans=$(../bin/max_err.pl run.txt gold.txt 1e-6)
if [ "$ans" -eq 0 ]; then
     echo Validation failed
     exit 1
fi

rm -f run.txt gold.txt

echo Validation succeded
exit 0
