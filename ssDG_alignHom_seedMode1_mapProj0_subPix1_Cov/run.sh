#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --bundle-adjust-prefix ../data/ba_grand_mesa/run --alignment-method affineepipolar --stereo-algorithm asp_mgm --subpixel-mode 9 -t dg --compute-point-cloud-covariances ../data/grand_mesa_WV03_left_crop.tif ../data/grand_mesa_WV03_right_crop.tif ../data/grand_mesa_WV03_left.xml ../data/grand_mesa_WV03_right.xml run/run --left-image-crop-win 17660 5330 579 610 --right-image-crop-win 5116 15520 720 688 --corr-tile-size 5000

point2dem --covariances run/run-PC.tif 

