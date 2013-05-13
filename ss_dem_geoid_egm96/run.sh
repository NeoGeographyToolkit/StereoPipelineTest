#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

dem_geoid $d/zone10-CA_SanLuisResevoir-9m_crop.tif -o run/run --double

