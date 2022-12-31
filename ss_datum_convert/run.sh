#!/bin/bash

set -x verbose
rm -rfv run

# Generate copy of the DEM in a new datum
datum_convert ../data/san_luis_dam_75m.dem.tif run/san_luis_dam_75m_wgs84.tif --output-datum wgs84

