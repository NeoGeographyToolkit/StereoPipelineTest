#!/bin/bash

set -x verbose
rm -rfv run

# Fit a separate water-surface plane to each connected water body (lake) in an
# ortho land/water mask, writing a per-pixel water-surface-elevation raster.
bathy_plane_calc                                     \
  --dem ../data/multibody_dem.tif                    \
  --ortho-mask ../data/multibody_ortho_mask.tif      \
  --min-water-body-pixels 300                              \
  --outlier-threshold 2.0                            \
  --output-water-surface run/wse.tif                 \
  --output-inlier-shapefile run/inliers.shp
