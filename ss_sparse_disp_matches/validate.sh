#!/bin/bash
source ../bin/setup_env.sh

# The sub-pixel match file is the product. Compare it against the gold copy.
# This test runs on Linux (lunokhod1) only, where the run and the gold are
# produced on the same platform, so an exact binary comparison is appropriate.

file=$(ls run/run-*.match 2>/dev/null)
gold=$(ls gold/run-*.match 2>/dev/null)

if [ ! -e "$file" ]; then
    echo "ERROR: no match file produced by sparse_disp."
    exit 1
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: gold match file does not exist."
    exit 1
fi

echo Comparing $file and $gold
if cmp -s "$file" "$gold"; then
    echo Validation succeeded
    exit 0
fi

echo Validation failed
exit 1
