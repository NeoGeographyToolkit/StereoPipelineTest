#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Find the 'bathy' conda env python. It has extra modules not in ASP's own
# python. The conda base differs by machine (miniconda3 on the nightly,
# anaconda3 on a Mac) and both may be present, so probe them in a fixed order
# and use the first that has the env.
bathy_py=""
for base in "$HOME/miniconda3" "$HOME/anaconda3"; do
    if [ -x "$base/envs/bathy/bin/python" ]; then
        bathy_py="$base/envs/bathy/bin/python"
        break
    fi
done
if [ -z "$bathy_py" ]; then
    echo "ERROR: could not find the bathy conda env python." 1>&2
    exit 1
fi

# Estimate the water-land threshold from the NIR (band 7) image with the KDE
# histogram tool. This is kept as its own test, separate from the bathy stereo
# test (ssDG_alignAffEpp_seedMode1_mapProj0_bathy).
$bathy_py $(which bathy_threshold_calc.py)                 \
    --image ../data/left_bathy_b7.tif --num-samples 100000 \
    --no-plot | grep -v -i elapsed > run/run-threshold.txt
