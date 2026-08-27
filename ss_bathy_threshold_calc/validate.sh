#!/bin/bash

source ../bin/setup_env.sh

file=run/run-threshold.txt
gold=gold/run-threshold.txt

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1
fi

# Extract the suggested threshold value (the number on the "Suggested
# threshold" line) from the run and the gold.
val=$(grep -i "Suggested threshold" "$file" | grep -oE "[0-9]+\.[0-9]+" | tail -n 1)
goldval=$(grep -i "Suggested threshold" "$gold" | grep -oE "[0-9]+\.[0-9]+" | tail -n 1)

if [ -z "$val" ] || [ -z "$goldval" ]; then
    echo "ERROR: Could not parse the suggested threshold."
    exit 1
fi

# Compare with a relative tolerance. The KDE minimum can shift slightly across
# Python module versions, so an exact text diff is too strict here.
tol=0.05
ok=$(awk -v a="$val" -v b="$goldval" -v t="$tol" \
    'BEGIN{d=a-b; if(d<0)d=-d; r=(b!=0)?d/b:d; print (r<=t)?"1":"0"}')

echo "Suggested threshold: run=$val gold=$goldval (rel tol $tol)"

if [ "$ok" != "1" ]; then
    echo Bathy threshold validation failed
    exit 1
fi

echo Validation succeeded
exit 0
