#!/bin/bash

# Test parallel_stereo with mapprojected images and --num-matches-from-disp-triplets

parallel_stereo ../data/B17_016219_1978_XN_17N282W.8bit.map.tif ../data/B18_016575_1978_XN_17N282W.8bit.map.tif ../data/B17_016219_1978_XN_17N282W.8bit.json ../data/B18_016575_1978_XN_17N282W.8bit.json run/run ../data/linescanDEM.tif --num-matches-from-disp-triplets 1000 --threads 1

point2dem run/run-PC.tif

