#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo ../data/LSZ_01636_1CD_XKU_09N120_S1.8bit.cub ../data/LSZ_02330_1CD_XKU_00S120_S1.8bit.cub ../data/LSZ_01636_1CD_XKU_09N120_S1.8bit.state.json ../data/LSZ_02330_1CD_XKU_00S120_S1.8bit.state.json run/run --stereo-algorithm asp_mgm --left-image-crop-win -80 9980 550 550 --right-image-crop-win 1222 48549 1100 1000

point2dem run/run-PC.tif --errorimage

