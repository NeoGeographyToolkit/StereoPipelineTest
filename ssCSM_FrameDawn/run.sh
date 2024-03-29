#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust ../data/FC21B0004011_11224024300F1E.cub ../data/FC21B0004012_11224030401F1E.cub ../data/FC21B0004011_11224024300F1E.json ../data/FC21B0004012_11224030401F1E.json -o run/ba/run --threads 1

# Try second bundle adjustment, to see if we can load the state
bundle_adjust ../data/FC21B0004011_11224024300F1E.cub ../data/FC21B0004012_11224030401F1E.cub run/ba/run-FC21B0004011_11224024300F1E.adjusted_state.json run/ba/run-FC21B0004012_11224030401F1E.adjusted_state.json -o run/ba_state/run --threads 1

parallel_stereo --bundle-adjust-prefix run/ba/run --stereo-algorithm asp_mgm --left-image-crop-win 243 161 707 825 --right-image-crop-win 314 109 663 869 ../data/FC21B0004011_11224024300F1E.cub ../data/FC21B0004012_11224030401F1E.cub ../data/FC21B0004011_11224024300F1E.json ../data/FC21B0004012_11224030401F1E.json run/run
point2dem run/run-PC.tif

