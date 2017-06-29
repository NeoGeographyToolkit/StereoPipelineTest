#!/bin/bash

set -x verbose
rm -rfv run

# Test point2dem with an unusual projection, specified via a WKT string

WKT='PROJCS["NZGD2000 / New Zealand Transverse Mercator 2000",                            
     GEOGCS["NZGD2000",
        DATUM["New_Zealand_Geodetic_Datum_2000",
            SPHEROID["GRS 1980",6378137,298.257222101,
                AUTHORITY["EPSG","7019"]],
            TOWGS84[0,0,0,0,0,0,0],
            AUTHORITY["EPSG","6167"]],
        PRIMEM["Greenwich",0,
            AUTHORITY["EPSG","8901"]],
        UNIT["degree",0.0174532925199433,
            AUTHORITY["EPSG","9122"]],
        AUTHORITY["EPSG","4167"]],
    PROJECTION["Transverse_Mercator"],
    PARAMETER["latitude_of_origin",0],
    PARAMETER["central_meridian",173],
    PARAMETER["scale_factor",0.9996],
    PARAMETER["false_easting",1600000],
    PARAMETER["false_northing",10000000],
    UNIT["metre",1,
        AUTHORITY["EPSG","9001"]],
    AUTHORITY["EPSG","2193"]]'

mkdir -p run

echo '1599985 10000045  5 ' > run/run.csv
echo '1600125  9999945 -6 ' >> run/run.csv

point2dem --t_srs "$WKT" --csv-format '1:easting 2:northing 3:height_above_datum' --tr 2 run/run.csv

