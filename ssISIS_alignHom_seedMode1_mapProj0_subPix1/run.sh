#!/bin/bash

set -x verbose
rm -rfv run

ip_method=2
isMac=$(uname -a |grep Darwin)
if [ "$isMac" != "" ]; then
    # On the Mac the OpenCV detectors seem to give non-unique answers
	ip_method=0
fi

stereo --enable-fill-holes ../data/M0100115.cub ../data/E0201461.cub run/run -s stereo.default --left-image-crop-win 0 1024 672 4864 --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1 --filter-mode 2 --ip-detect-method 0 --save-left-right-disparity-difference
point2dem run/run-PC.tif --nodata-value -32767 --errorimage   --auto-proj-center --orthographic
#point2dem --t_srs http://spatialreference.org/ref/iau2000/49900/  run/run-PC.tif --nodata-value -32767 --errorimage  

