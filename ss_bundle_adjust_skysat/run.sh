#!/bin/bash

set -x verbose
rm -rfv run

parallel_bundle_adjust ../data/skysat/a*tiff                       \
    --auto-overlap-params "../data/skysat/uluru_copernicus.tif 10" \
	-o run/run

