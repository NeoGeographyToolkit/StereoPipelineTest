#!/bin/bash
export PATH=../bin:$PATH

file=run/run-DEM.tif
gold=gold/run-DEM.tif

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
gdalinfo -stats $file | grep -v Files | grep -v -i tif | grep -i -v minimum > run/run.txt
gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v minimum > gold/run.txt

diff=$(diff run/run.txt gold/run.txt)
cat run/run.txt

# Print the error and check the status
../bin/max_err.pl run/run.txt gold/run.txt
ans=$?
if [ "$ans" -ne 0 ]; then
	echo Validation failed
	exit 1
fi

ans=$(../bin/max_err.pl run/run.txt gold/run.txt 0.001) # compare the error
if [ "$ans" != "1" ]; then
    echo Validation failed
    exit 1
fi

rm -f run/run.txt gold/run.txt

echo Validation succeeded
exit 0
