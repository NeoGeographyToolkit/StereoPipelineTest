#!/bin/bash

set -x verbose
rm -rfv run

# First find matches with bundle_adjust
bundle_adjust --threads 1 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub ../data/B17_016219_1978_XN_17N282W.8bit.json ../data/B18_016575_1978_XN_17N282W.8bit.json -o run/run

# Solve for jitter. Modify the .cub files. Test --input-adjustments-prefix.
/bin/cp -fv ../data/B17_016219_1978_XN_17N282W.8bit.cub run
/bin/cp -fv ../data/B18_016575_1978_XN_17N282W.8bit.cub run

jitter_solve --threads 1                        \
   run/B17_016219_1978_XN_17N282W.8bit.cub      \
	 run/B18_016575_1978_XN_17N282W.8bit.cub      \
	 ../data/B17_016219_1978_XN_17N282W.8bit.json \
	 ../data/B18_016575_1978_XN_17N282W.8bit.json \
	 --input-adjustments-prefix run/run           \
	 --match-files-prefix run/run                 \
	 --num-iterations 5                           \
	 --update-isis-cubes-with-csm-state           \
	 -o run/jitter

