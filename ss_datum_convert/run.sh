#!/bin/bash

set -x verbose
rm -rfv run


# Generate copy of the DEM in a new datum
mkdir run
datum_convert ../data/san_luis_dam_75m.dem.tif wgs84 run/san_luis_dam_75m_wgs84.tif


