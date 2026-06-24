#!/bin/bash

# Self-contained sparse_disp (corr-seed-mode 3) test. Runs sparse_disp directly
# on a small left/right pair, with no ISIS cameras and no full stereo run. This
# exercises that sparse_disp and its bundled Python modules (numpy, scipy, gdal)
# are present and working in the shipped ASP. No ASP_PYTHON_MODULES_PATH is set,
# so the test relies on the Python environment shipped with ASP.

set -x verbose
rm -rfv run
mkdir -p run

sparse_disp L.tif R.tif run/run
