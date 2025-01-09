#!/bin/bash

set -x verbose
rm -rfv run

# Test a CSV dataset having data crossing the 180 degree meridian

point2dem --t_srs "+proj=stere +lat_0=90 +lat_ts=70 +lon_0=-45 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs" --csv-format '1:lon 2:lat 3:height_above_datum' --tr 1000 ../data/cloud_180deg.csv -o run/run-stere

point2dem --t_srs "+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs" --csv-format '1:lon 2:lat 3:height_above_datum' --tr 1000 ../data/cloud_180deg.csv -o run/run-utm

point2dem -r earth --csv-format 1:lon,2:lat,3:height_above_datum ../data/cloud_180deg.csv -o run/run-lonlat --tr 2000

# The EPSG:6318 / "NAD83(2011)" geographic CRS as a GeoJSON string
srs='
{
  "$schema": "https://proj.org/schemas/v0.4/projjson.schema.json",
  "type": "GeographicCRS",
  "name": "NAD83(2011)",
  "datum": {
    "type": "GeodeticReferenceFrame",
    "name": "NAD83 (National Spatial Reference System 2011)",
    "ellipsoid": {
      "name": "GRS 1980",
      "semi_major_axis": 6378137,
      "inverse_flattening": 298.257222101
    }
  },
  "coordinate_system": {
    "subtype": "ellipsoidal",
    "axis": [
      {
        "name": "Geodetic latitude",
        "abbreviation": "Lat",
        "direction": "north",
        "unit": "degree"
      },
      {
        "name": "Geodetic longitude",
        "abbreviation": "Lon",
        "direction": "east",
        "unit": "degree"
      }
    ]
  },
  "scope": "Horizontal component of 3D system.",
  "area": "Puerto Rico - onshore and offshore. United States (USA) onshore and offshore - Alabama; Alaska; Arizona; Arkansas; California; Colorado; Connecticut; Delaware; Florida; Georgia; Idaho; Illinois; Indiana; Iowa; Kansas; Kentucky; Louisiana; Maine; Maryland; Massachusetts; Michigan; Minnesota; Mississippi; Missouri; Montana; Nebraska; Nevada; New Hampshire; New Jersey; New Mexico; New York; North Carolina; North Dakota; Ohio; Oklahoma; Oregon; Pennsylvania; Rhode Island; South Carolina; South Dakota; Tennessee; Texas; Utah; Vermont; Virginia; Washington; West Virginia; Wisconsin; Wyoming. US Virgin Islands - onshore and offshore.",
  "bbox": {
    "south_latitude": 14.92,
    "west_longitude": 167.65,
    "north_latitude": 74.71,
    "east_longitude": -63.88
  },
  "id": {
    "authority": "EPSG",
    "code": 6318
  }
}
'

point2dem --t_srs "$srs" --csv-format 1:lon,2:lat,3:height_above_datum ../data/cloud_180deg.csv -o run/run-json --tr 0.5

