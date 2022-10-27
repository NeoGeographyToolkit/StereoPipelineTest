#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/IMG_PER1_20171207153639_SEN_P_000041_crop.tif ../data/IMG_PER1_20171207153815_SEN_P_000041_crop.tif ../data/DIM_PER1_20171207153639_SEN_P_000041.XML ../data/DIM_PER1_20171207153815_SEN_P_000041.XML run/run

point2dem run/run-PC.tif

