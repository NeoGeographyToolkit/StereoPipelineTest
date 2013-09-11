#!/bin/bash

set -x verbose
rm -rfv run

dem_geoid ../data/zone10-CA_SanLuisResevoir-9m_crop_nad83.tif -o run/run 

