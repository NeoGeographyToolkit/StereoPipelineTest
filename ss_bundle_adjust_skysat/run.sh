#!/bin/bash

set -x verbose
rm -rfv run

parallel_bundle_adjust                                                            \
  ../data/skysat/a1000.tiff  ../data/skysat/a1020.tiff  ../data/skysat/a1040.tiff \
  ../data/skysat/a1010.tiff  ../data/skysat/a1030.tiff  ../data/skysat/a1050.tiff \
  --threads 1 --auto-overlap-params "../data/skysat/uluru_copernicus.tif 10"      \
  -o run/run --num-passes 1 --num-iterations 10 --ip-per-image 200

