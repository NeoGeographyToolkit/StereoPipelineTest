#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust ../data/AS15-M-1134.lev1.tif ../data/AS15-M-1135.lev1.tif -o run/run --datum D_MOON --max-iterations 200

