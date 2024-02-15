#!/bin/bash

set -x verbose
rm -rfv run

# Test a WKT string

srs='
PROJCRS["WGS 84 (G2139) / UTM 4N",
    BASEGEOGCRS["WGS 84 (G2139)",
    DYNAMIC[
        FRAMEEPOCH[2016]],
    DATUM["World Geodetic System 1984 (G2139)",
        ELLIPSOID["WGS 84",6378137,298.257223563,
            LENGTHUNIT["metre",1]]],
    PRIMEM["Greenwich",0,
        ANGLEUNIT["degree",0.0174532925199433]],
	ID["EPSG",9754]],
   CONVERSION["UTM zone 4N",
        METHOD["Transverse Mercator",
            ID["EPSG",9807]],
        PARAMETER["Latitude of natural origin",0,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8801]],
        PARAMETER["Longitude of natural origin",-159,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8802]],
        PARAMETER["Scale factor at natural origin",0.9996,
            SCALEUNIT["unity",1],
            ID["EPSG",8805]],
        PARAMETER["False easting",500000,
            LENGTHUNIT["metre",1],
            ID["EPSG",8806]],
        PARAMETER["False northing",0,
            LENGTHUNIT["metre",1],
            ID["EPSG",8807]]],
    CS[Cartesian,3],
        AXIS["(E)",north,
            MERIDIAN[90,
                ANGLEUNIT["degree", 0.0174532925199433]],
            ORDER[1],
            LENGTHUNIT["metre",1]],
        AXIS["(N)",north,
            MERIDIAN[0,
                ANGLEUNIT["degree", 0.0174532925199433]],
            ORDER[2],
            LENGTHUNIT["metre",1]],
        AXIS["ellipsoidal height (h)",up,
            ORDER[3],
            LENGTHUNIT["metre",1,
                ID["EPSG",9001]]]]
'

point2dem --t_srs "$srs" ../data/alaska-PC.tif -o run/run

