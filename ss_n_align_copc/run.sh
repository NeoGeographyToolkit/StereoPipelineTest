#!/bin/bash

# Test that n_align reads a LAZ COPC file, cropped with --copc-win to the same
# region as the other cloud. Zero iterations gives identity transforms, so the
# result is deterministic; the point of the test is that the COPC input is read.

set -x verbose
rm -rfv run

n_align ../data/autzen-classified.crop.laz \
        ../data/autzen-classified.copc.laz \
        --copc-win 636400 852260 638180 849990 \
        --num-iterations 0 \
        --max-num-points 50000 \
        --csv-format utm:10N,1:easting,2:northing,3:height_above_datum \
        --output-prefix run/run
