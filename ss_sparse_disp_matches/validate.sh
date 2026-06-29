#!/bin/bash
source ../bin/setup_env.sh

# Two plain-text sub-pixel match files are the products, one per uncertainty mode
# (parabola_curvature and cramer_rao). Each is compared against its gold copy.
# This test runs on Linux (lunokhod1) only, where the run and the gold are
# produced on the same platform, so an exact comparison is appropriate. The files
# are plain text (x1 y1 unc1 x2 y2 unc2), so a mismatch can be inspected directly.

status=0
for mode in parabola_curvature cramer_rao; do
    file=$(ls run/m_${mode}-*.txt 2>/dev/null)
    gold=$(ls gold/m_${mode}-*.txt 2>/dev/null)

    if [ ! -e "$file" ]; then
        echo "ERROR: no match file produced by sparse_disp for mode ${mode}."
        status=1
        continue
    fi

    if [ ! -e "$gold" ]; then
        echo "ERROR: gold match file does not exist for mode ${mode}."
        status=1
        continue
    fi

    echo "Comparing $file and $gold"
    if cmp -s "$file" "$gold"; then
        echo "  mode ${mode}: match"
    else
        echo "  mode ${mode}: MISMATCH"
        status=1
    fi
done

if [ "$status" -eq 0 ]; then
    echo Validation succeeded
    exit 0
fi

echo Validation failed
exit 1
