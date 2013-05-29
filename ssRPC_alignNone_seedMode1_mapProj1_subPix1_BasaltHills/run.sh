#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

stereo $d/09OCT11191503-P1BS_R1C1-052783426010_01_P001_rpc_5mpp.tif $d/09OCT11191555-P1BS_R1C1-052783426010_01_P001_rpc_5mpp.tif $d/09OCT11191503-P1BS_R1C1-052783426010_01_P001_rpc.xml $d/09OCT11191555-P1BS_R1C1-052783426010_01_P001_rpc.xml $dir/$dir $d/zone10-CA_SanLuisResevoir-9m.tif --corr-max-levels 5 -t rpc -s stereo.default --alignment-method none --subpixel-mode 1 --disable-fill-holes --threads 32 --subpixel-h-kernel 19 --subpixel-v-kernel 19 --corr-seed-mode 1 --left-image-crop-win 1024 1024 1024 2048

point2dem -r Earth $dir/$dir-PC.tif --nodata-value -32767

