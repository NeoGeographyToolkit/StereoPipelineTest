#!/bin/bash
source ../bin/setup_env.sh

# Gold-diff the grid and statistics of the mosaicked tile. A single-DEM mosaic
# must reproduce the input DEM, and gold was seeded from a correct run, so a
# match to gold confirms the identity (size, origin, pixel size, statistics,
# no-data).
file=run/stats.txt
gold=gold/stats.txt

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

echo diff $file $gold
diff=$(diff $file $gold)

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
