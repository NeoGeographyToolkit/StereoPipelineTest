#!/bin/bash
export PATH=../bin:$PATH

file=run/run-trans_reference.laz
gold=gold/run-trans_reference.laz

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

pdal info --all $file | grep -v filename | grep -v date | grep -i -v software | grep -v now | grep -v creation | grep -v href > run/run.txt
ans=$?
if [ $ans -ne 0 ]; then
    echo Validation failed
    exit 1
fi

pdal info --all $gold |grep -v filename | grep -v date | grep -i -v software | grep -v now | grep -v creation | grep -v href > gold/run.txt
ans=$?
if [ $ans -ne 0 ]; then
    echo Validation failed
    exit 1
fi

diff=$(diff run/run.txt gold/run.txt | head -n 50)

rm -f run/run.txt gold/run.txt

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

diff=$(diff $file $gold| head -n 100)
echo "diff is $diff"

../bin/max_err.pl $file $gold
ans=$(../bin/max_err.pl $file $gold 1e-10 | grep -v Warn) # compare the error
if [ "$ans" -eq 0 ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0

