#!/bin/bash
source ../bin/setup_env.sh

file=run/run-trans_reference.tif
gold=gold/$(basename $file)

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

diff=$(diff run/run.txt gold/run.txt | head -n 50)
cat run/run.txt

rm -f run/run.txt gold/run.txt

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

file=run/run-trans_source.csv
gold=gold/$(basename $file)

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

# Compare with a tight relative tolerance. On this platform the run and gold are
# produced identically, so this only absorbs last-digit float noise from
# evaluation-order changes. The Mac/ARM cloud copy of this test uses a looser
# tolerance, since there the gold comes from a different platform.
../bin/max_err.pl $file $gold
tol=1e-10
ans=$(../bin/max_err.pl $file $gold $tol)
if [ "$ans" != "1" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0

