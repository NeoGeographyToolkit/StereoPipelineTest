#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --stereo-algorithm asp_mgm --subpixel-mode 9 ../data/IMG_PNEO4_202304032140366_PAN_SEN_PWOI_000079416_1_2_F_1_P_R1C1_crop.tif ../data/IMG_PNEO4_202304032140266_PAN_SEN_PWOI_000079416_1_2_F_1_P_R1C1_crop.tif ../data/DIM_PNEO4_202304032140366_PAN_SEN_PWOI_000079416_1_2_F_1.XML ../data/DIM_PNEO4_202304032140266_PAN_SEN_PWOI_000079416_1_2_F_1.XML run/run
point2dem --stereographic --proj-lon 212.246 --proj-lat 64.897 --errorimage run/run-PC.tif

