#!/bin/bash
source ../bin/setup_env.sh

# The discriminating signal is the number of clean matches that survive the
# solve. With image normalization for the OBALoG detector the two low-contrast
# same-look framelets yield about 164 clean matches. Without it the matches are
# geometrically inconsistent and all get filtered out, so the clean match file
# is absent (bundle_adjust fails with "Too few points"). Require a floor well
# above zero and well below the count the fixed build produces.

mf=run/run-cassis_ox2_L1_fr00__cassis_ox2_L1_fr01-clean.match

if [ ! -e "$mf" ]; then
    echo "ERROR: clean match file $mf does not exist."
    echo "OBALoG same-look matching collapsed. Normalization may not run for all detectors."
    echo Validation failed
    exit 1
fi

# The match file starts with two little-endian uint64 counts, both equal to the
# number of matched pairs. Read the first one.
n=$(python3 -c "import struct; print(struct.unpack('<Q', open('$mf','rb').read(8))[0])")
echo "OBALoG clean matches: $n"

if [ "$n" -lt 50 ]; then
    echo "ERROR: only $n clean matches (expected about 164)."
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
