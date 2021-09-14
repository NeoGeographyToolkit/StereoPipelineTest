#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/LSZ_01636_1CD_XKU_09N120_S1.8bit_crop.cub ../data/LSZ_02331_1CD_XKU_15N120_S1.8bit_crop.cub run/run --ip-per-tile 10000 --min-num-ip 20

point2dem run/run-PC.tif

