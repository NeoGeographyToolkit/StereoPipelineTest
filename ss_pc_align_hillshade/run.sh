#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif ../data/filled_dem_scaled.tif --max-displacement 300 -o run/run --alignment-method point-to-plane --save-transformed-source-points --num-iterations 100 --initial-transform-from-hillshading similarity

