#!/bin/bash
export PATH=../bin:$PATH

file=run/run-LAS.las
gold=gold/$(basename $file)

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

# Oddly enough, this is necessary
if [ "$(uname -s)" = "Darwin" ]; then
   export DYLD_LIBRARY_PATH=$(dirname $(which pdal))/../lib
fi

pdal info --metadata $file | grep -v filename | grep -v date | grep -i -v software | grep -v now | grep -v creation | grep -v href > run/run.txt
status=$?
if [ $status -ne 0 ]; then
    echo Validation failed
    exit 1
fi

pdal info --metadata $gold | grep -v filename | grep -v date | grep -i -v software | grep -v now | grep -v creation | grep -v href > gold/run.txt
status=$?
if [ $status -ne 0 ]; then
    echo Validation failed
    exit 1
fi

diff=$(diff run/run.txt gold/run.txt)
cat run/run.txt

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
