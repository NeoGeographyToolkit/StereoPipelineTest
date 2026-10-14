#!/bin/bash

set -x verbose
rm -rfv run

# Legacy fill: replace the permanently shadowed holes with the LOLA DEM.
sfs_blend                                          \
    --shadow-fill-mode lola                        \
    --image-threshold 0.005                        \
    --lit-blend-length 50                          \
    --shadow-blend-length 5                        \
    --min-blend-size 50                            \
    --weight-blur-sigma 5                          \
    --lola-dem ../data/lola_clip.tif               \
    --sfs-dem ../data/sfs_clip.tif                 \
    --max-lit-image-mosaic ../data/maxlit_clip.tif \
    --output-dem run/sfs_blend_lola.tif            \
    --output-weight run/sfs_weight_lola.tif

# Default fill: the per-pixel minimum of the SfS, the LOLA DEM, and a surface
# grown from the surrounding SfS that curves gently downward.
sfs_blend                                          \
    --shadow-fill-mode lola-curved                 \
    --shadow-fill-max-diameter 300                 \
    --image-threshold 0.005                        \
    --lit-blend-length 20                          \
    --shadow-blend-length 20                       \
    --min-blend-size 25                            \
    --weight-blur-sigma 10                         \
    --lola-dem ../data/lola_clip.tif               \
    --sfs-dem ../data/sfs_clip.tif                 \
    --max-lit-image-mosaic ../data/maxlit_clip.tif \
    --output-dem run/sfs_blend_curved.tif          \
    --output-weight run/sfs_weight_curved.tif
