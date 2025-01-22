#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --stereo-algorithm asp_mgm ../data/dg_ortho/left_regrid.tif ../data/dg_ortho/right_regrid.tif ../data/dg_ortho/25JAN15185222-P2AS-200007010928_01_P001.XML ../data/dg_ortho/25JAN16185415-P2AS-200007018742_01_P001.XML --left-image-crop-win 962 1493 1000 1000 --right-image-crop-win 1879 2489 1694 1570 run/run
point2dem run/run-PC.tif

