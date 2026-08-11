#!/bin/bash

# Test that point2dem, pc_align, and n_align accept GDAL virtual file system
# paths (/vsizip/, /vsitar/, /vsicurl/, ...). See issue 498 and pull 499.
# A single ASP point cloud is wrapped in a local zip, then read by all three
# tools through a /vsizip/ path. This exercises the same input-existence code
# that rejected such paths before, without needing the network. The archive is
# uncompressed (-0), so GDAL gets full random access.

set -x verbose
rm -rfv run
mkdir -p run

# Wrap the shared point cloud in a zip. -j drops the directory, -0 stores it.
zip -j -0 run/alaska-PC.zip ../data/alaska-PC.tif

vsi=/vsizip/$PWD/run/alaska-PC.zip/alaska-PC.tif

# point2dem: rasterize the cloud read from the archive.
mkdir -p run/point2dem
point2dem --tr 10 --t_projwin -191775 -2265255 -190865 -2266205 \
  $vsi -o run/point2dem/run

# pc_align: align the cloud to itself. With zero iterations and no displacement
# limit the transform is the identity, so the result is deterministic. The point
# of the test is that the /vsizip/ inputs are accepted, not the alignment.
mkdir -p run/pc_align
pc_align --max-displacement -1 --num-iterations 0 \
  $vsi $vsi -o run/pc_align/run

# n_align: same cloud passed twice, zero iterations, identity transforms.
mkdir -p run/n_align
n_align --num-iterations 0 --max-num-points 5000 \
  $vsi $vsi -o run/n_align/run
