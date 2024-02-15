#!/bin/bash

set -x verbose
rm -rfv run

# Test writing a LAS file with a Moon wkt
srs='GEOGCRS["Moon(2015)-Sphere/Ocentric",DATUM["Moon(2015)-Sphere",ELLIPSOID["Moon(2015)-Sphere",1737400,0,LENGTHUNIT["metre",1]],ID["IAU",30100,2015]],PRIMEM["ReferenceMeridian",0,ANGLEUNIT["degree",0.0174532925199433],ID["IAU",30100,2015]],CS[ellipsoidal,3],AXIS["geodeticlatitude(Lat)",north,ORDER[1],ANGLEUNIT["degree",0.0174532925199433,ID["EPSG",9122]]],AXIS["geodeticlongitude(Lon)",east,ORDER[2],ANGLEUNIT["degree",0.0174532925199433,ID["EPSG",9122]]],AXIS["ellipsoidalheight(h)",up,ORDER[3],LENGTHUNIT["metre",1,ID["EPSG",9001]]],REMARK["Promotedto3DfromIAU_2015:30100.SourceofIAUCoordinatesystems:https://doi.org/10.1007/s10569-017-9805-5"]]'

point2las --t_srs "$srs" ../data/moon-PC.tif -o run/run

