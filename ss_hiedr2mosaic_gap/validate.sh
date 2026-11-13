#!/bin/bash
source ../bin/setup_env.sh

# Gold-diff the hiedr2mosaic log. It records the ISIS step sequence (hi2isis,
# hical, histitch, spiceinit, spicefit, noproj, hijitreg, handmos, cubenorm,
# Finished) with relative paths only, so it is deterministic. A match to gold
# confirms the gap-handling path ran all steps with no KeyError on a missing CCD.
file=run/output.txt
gold=gold/output.txt

if [ ! -s "$file" ]; then
    echo "ERROR: $file is missing or empty."
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
