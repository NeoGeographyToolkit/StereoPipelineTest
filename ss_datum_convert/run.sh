#!/bin/bash

set -x verbose
rm -rfv run


# Generate copy of the DEM in a new datum
mkdir run
datum_convert ../data/san_luis_dam_75m.dem wgs84 run/san_luis_dam_75m_wgs84.tif

# Convert both images to point clouds
dem_to_pc ../data/san_luis_dam_75m.dem   run/san_luis_dam_75m_pc.tif
dem_to_pc run/san_luis_dam_75m_wgs84.tif run/san_luis_dam_75m_wgs84_pc.tif

# Compare the position of the point clouds
pc_align run/san_luis_dam_75m_pc.tif run/san_luis_dam_75m_wgs84_pc.tif --max-displacement -1 --compute-translation-only


