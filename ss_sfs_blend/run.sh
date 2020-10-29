#!/bin/bash

set -x verbose
rm -rfv run

sfs_blend --lola-dem ../data/sfs-DEM.tif --sfs-dem ../data/sfs-DEM-out.tif --max-lit-image-mosaic ../data/sfs-image.tif --output-dem run/run-blend.tif --output-weight run/run-weight.tif --image-threshold 0.029 --lit-blend-length 2 --shadow-blend-length 2 --min-blend-size 2 --weight-blur-sigma 0.1

