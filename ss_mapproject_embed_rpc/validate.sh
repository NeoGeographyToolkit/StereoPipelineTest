#!/bin/bash
export PATH=../bin:$PATH

# Compare the query results
file=run/run-query.txt
gold=gold/run-query.txt

echo Comparing run/run-query.txt gold/run-query.txt
ans=$(../bin/max_err.pl run/run-query.txt gold/run-query.txt 1e-9)
if [ "$ans" != "1" ]; then
     echo Validation failed
     exit 1
fi
echo Files agree

# Compare the tif files
file=run/run-RPC.tif
gold=gold/run-RPC.tif
echo Comparing $file $gold

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

diff=$(diff run/run.txt goldrun/.txt | head -n 50)
cat run/run.txt
echo Diff is $diff

../bin/max_err.pl run/run.txt gold/run.txt
ans=$(../bin/max_err.pl run/run.txt gold/run.txt 1e-9)
if [ "$ans" -eq 0 ]; then
     echo Validation failed
     exit 1
fi

echo Validation succeeded
exit 0
