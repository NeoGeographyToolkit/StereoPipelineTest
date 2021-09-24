#!/bin/bash

set -x verbose
rm -rfv run

# Run with the exact model
parallel_stereo --left-image-crop-win 2183 5582 1748 1500 --right-image-crop-win 2095 7993 2338 2207 --corr-seed-mode 1 --threads 16 ../data/IMG_PER1_20171207153639_SEN_P_000041_crop.tif ../data/IMG_PER1_20171207153815_SEN_P_000041_crop.tif ../data/DIM_PER1_20171207153639_SEN_P_000041.XML ../data/DIM_PER1_20171207153815_SEN_P_000041.XML run/run-exact
point2dem run/run-exact-PC.tif

# Run with the rpc model
parallel_stereo --left-image-crop-win 2183 5582 1748 1500 --right-image-crop-win 2095 7993 2338 2207 --corr-seed-mode 1 --threads 16 ../data/IMG_PER1_20171207153639_SEN_P_000041_crop.tif ../data/IMG_PER1_20171207153815_SEN_P_000041_crop.tif ../data/RPC_PER1_20171207153639_SEN_P_000041.XML ../data/RPC_PER1_20171207153815_SEN_P_000041.XML  run/run-rpc
point2dem run/run-rpc-PC.tif

