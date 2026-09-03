#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Find the 'bathy' conda env python. It has extra modules (gdal, scipy, numpy,
# matplotlib) that are not in ASP's own python. The conda base differs by
# machine (miniconda3 on the nightly, anaconda3 on a Mac) and both may be
# present, so probe them in a fixed order and use the first that has the env.
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

# Remove sun glint from the green band with the Hedley method.
$bathy_py $(which glint_correct)                                      \
    --image ../data/glint_green.tif --nir-image ../data/glint_nir.tif \
    --mask ../data/glint_mask.tif --deep-water-buffer 30              \
    --output-image run/glint_deglint.tif > run/run-log.txt 2>&1
