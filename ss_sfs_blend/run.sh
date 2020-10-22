#!/bin/bash

set -x verbose
rm -rfv run

sfs_blend --lola-dem ../data/sfs-DEM.tif --sfs-dem ../data/sfs-DEM-out.tif --max-lit-image-mosaic ../data/sfs-image.tif --output-dem run/run-blend.tif --sfs-mask run/run-mask.tif --image-threshold 0.029 --blend-length 2 --min-blend-size 2 --weight-blur-sigma 0.1

