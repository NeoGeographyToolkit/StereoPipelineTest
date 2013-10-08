#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/filled_dem_sub10.tif ../data/zone10-CA_SanLuisResevoir-9m_sub10.tif --save-transformed-source-points --output-prefix run/run --max-displacement 1000

