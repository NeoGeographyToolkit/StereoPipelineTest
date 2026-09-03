#!/bin/bash

set -x verbose
rm -rfv run

# Find the 'orbit_plot' conda env python. The conda base differs by machine
# (miniconda3 on the nightly, anaconda3 on a Mac) and both may be present, so
# probe them in a fixed order and use the first that has the env.
op_py=""
for base in "$HOME/miniconda3" "$HOME/anaconda3"; do
    if [ -x "$base/envs/orbit_plot/bin/python" ]; then
        op_py="$base/envs/orbit_plot/bin/python"
        break
    fi
done
if [ -z "$op_py" ]; then
    echo "ERROR: could not find the orbit_plot conda env python." 1>&2
    exit 1
fi

# Test orbit_plot. Make the result go to file.
$op_py $(which orbit_plot.py) --subtract-line-fit --dataset ../data/orbit_plot/ --orbit-id c1,c4 --dataset-label orbit_plot --output-file run/run.png
