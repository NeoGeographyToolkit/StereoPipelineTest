#!/bin/bash
export PATH=../bin:$PATH

file=run/run-sample.shp
gold=gold/run-sample.shp

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

echo Comparing $file and $gold
diff=$(cmp $file $gold)

if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
