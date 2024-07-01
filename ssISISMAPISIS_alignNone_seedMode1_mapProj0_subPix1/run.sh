#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/M0100115.tif ../data/E0201461.tif ../data/M0100115.cub ../data/E0201461.cub run/run ../data/moc-ref-DEM.tif --left-image-crop-win 598 2990 485 531 --right-image-crop-win 30 3042 478 497

point2dem -r mars run/run-PC.tif --nodata-value -32767 --errorimage --fsaa 4 --use-surface-sampling

