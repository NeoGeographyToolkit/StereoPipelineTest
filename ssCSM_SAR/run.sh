#!/bin/bash

set -x verbose
rm -rfv run

# This is not a great testcase but the best available so far 
parallel_stereo --corr-kernel 45 45 --subpixel-kernel 45 45 --ip-per-tile 5000 --stereo-algorithm asp_bm --left-image-crop-win -201 8218 2123 3509 --right-image-crop-win 765 46111 2236 4471 --corr-seed-mode 1 --threads 16 ../data/LSZ_01636_1CD_XKU_09N120_S1.8bit.cub ../data/LSZ_02330_1CD_XKU_00S120_S1.8bit.cub ../data/LSZ_01636_1CD_XKU_09N120_S1.8bit_fixed.json ../data/LSZ_02330_1CD_XKU_00S120_S1.8bit_fixed.json run/run

point2dem run/run-PC.tif

