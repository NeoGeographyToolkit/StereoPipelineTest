#!/bin/bash

set -x verbose
rm -rfv run

# WorldView-3 green multispectral band (band 3) CCD correction, using the
# built-in correction table (share/wv_correct/WV03_BAND3_CCD_CORR.tif, selected
# by satellite/band/TDI/scan-direction via ms_correction_lookup.txt). This is a
# TDI-14 forward scene. A tiny crop; just exercises the built-in-table path.
wv_correct --band 3 ../data/WV03_MS_b3_14fwd_crop.tif ../data/WV03_MS_b3_14fwd.xml run/run.tif
