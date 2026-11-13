#!/bin/bash
source ../bin/setup_env.sh

# Gold-diff the GSD-mismatch error line that correlator mode must emit when the
# two georeferenced inputs have different ground sample distances. The line names
# the two fixed GSD values, so it is deterministic.
file=run/gsd_error.txt
gold=gold/gsd_error.txt

if [ ! -s "$file" ]; then
    echo "FAIL: GSD mismatch error not found in output"
    exit 1
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1
fi

echo diff $file $gold
diff=$(diff $file $gold | head -n 50)

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
