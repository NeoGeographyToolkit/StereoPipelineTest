#!/bin/bash

set -x verbose
rm -rfv run

dem_geoid ../data/zone10-CA_SanLuisResevoir-9m_crop.tif -o run/run --double

