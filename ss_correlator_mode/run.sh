#!/bin/bash

set -x verbose
rm -rfv run

# Standalone test for parallel_stereo --correlator-mode. This runs image
# correlation only, without cameras: it produces a disparity (run-F.tif)
# but no triangulated point cloud (run-PC.tif), and must clean up any
# per-tile subdirectories after merging the outputs.
mkdir -p run

parallel_stereo --correlator-mode ../data/left_clip.tif ../data/right_clip.tif run/run
