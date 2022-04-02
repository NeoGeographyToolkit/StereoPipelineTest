#!/bin/bash

set -x verbose
rm -rfv run

image_align ../data/image_crop.tif ../data/image_crop_4.5pix.tif -o run/run-align.tif --output-prefix run/run

