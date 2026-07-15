#!/bin/bash
source ../bin/setup_env.sh

file=run/run-out.txt
gold=gold/$(basename $file)

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1
fi

# An empty stats file means cam_test produced no output - typically the vendor
# CaSSIS model (CSM distortion type 9) failed to load, i.e. the ale/usgscsm in
# use lack CaSSIS. Fail loudly.
if [ ! -s "$file" ]; then
    echo "ERROR: File $file is empty. cam_test produced no stats (CaSSIS model failed to load?)."
    exit 1
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1
fi

# Tolerant compare. The reference gold may be produced on a different platform
# than the run (cloud Mac ARM64 / Linux ARM), so small last-digit differences in
# the pixel-diff numbers are fine. A real regression (CaSSIS not loaded) yields
# missing or wildly different values and fails here. max_err.pl returns 1 if the
# max relative error is below the tolerance, 0 otherwise.
../bin/max_err.pl $file $gold
ans=$(../bin/max_err.pl $file $gold 0.1)
if [ "$ans" -eq 0 ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
