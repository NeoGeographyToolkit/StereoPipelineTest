#!/bin/bash

# Test stereo_dist 

set -x verbose
rm -rfv run

# Test stereo_dist with --nodes-list
mkdir -p run
echo localhost > run/nodes.txt
stereo_dist ../data/B17_016219_1978_XN_17N282W.8bit.crop.map.tif ../data/B18_016575_1978_XN_17N282W.8bit.crop.map.tif ../data/B17_016219_1978_XN_17N282W.8bit.json ../data/B18_016575_1978_XN_17N282W.8bit.json run/run --dem ../data/linescanDEM.tif --tile-size 512 --tile-padding 128 --point2dem-options '--tr 10' --nodes-list run/nodes.txt

