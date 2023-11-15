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

# Include libexec in the path
export PATH=$(dirname $(which pdal))/../libexec:$PATH

# Oddly enough, this is necessary
if [ "$(uname -s)" = "Darwin" ]; then
   export DYLD_LIBRARY_PATH=$(dirname $(which pdal))/../lib
fi

pdal info --all $file | grep -v filename | grep -v now | grep -v creation > run.txt
status=$?
if [ $status -ne 0 ]; then
    echo Validation failed
    exit 1
fi

pdal info --all $gold |grep -v filename | grep -v now | grep -v creation > gold.txt
status=$?
if [ $status -ne 0 ]; then
    echo Validation failed
    exit 1
fi

diff=$(diff run.txt gold.txt)
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

diff=$(diff $file $gold| head -n 100)
echo "diff is $diff"
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeded
exit 0

