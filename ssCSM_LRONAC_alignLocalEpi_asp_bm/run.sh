#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --left-image-crop-win 3583 3922 1767 1691 --right-image-crop-win 4095 4348 1498 1668 --threads 16 --corr-seed-mode 1 ../data/M181058717LE.ce.cub ../data/M181073012LE.ce.cub ../data/M181058717LE.ce.json ../data/M181073012LE.ce.json run/run --corr-tile-size 3072 --sgm-collar-size 256 --alignment-method local_epipolar --stereo-algorithm asp_bm --save-left-right-disparity-difference

# Test writing a wkt
srs='GEOGCRS["Moon(2015)-Sphere/Ocentric",DATUM["Moon(2015)-Sphere",ELLIPSOID["Moon(2015)-Sphere",1737400,0,LENGTHUNIT["metre",1]],ID["IAU",30100,2015]],PRIMEM["ReferenceMeridian",0,ANGLEUNIT["degree",0.0174532925199433],ID["IAU",30100,2015]],CS[ellipsoidal,3],AXIS["geodeticlatitude(Lat)",north,ORDER[1],ANGLEUNIT["degree",0.0174532925199433,ID["EPSG",9122]]],AXIS["geodeticlongitude(Lon)",east,ORDER[2],ANGLEUNIT["degree",0.0174532925199433,ID["EPSG",9122]]],AXIS["ellipsoidalheight(h)",up,ORDER[3],LENGTHUNIT["metre",1,ID["EPSG",9001]]],REMARK["Promotedto3DfromIAU_2015:30100.SourceofIAUCoordinatesystems:https://doi.org/10.1007/s10569-017-9805-5"]]'

point2dem --t_srs "$srs" run/run-PC.tif

