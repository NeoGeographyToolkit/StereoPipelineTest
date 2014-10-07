#!/bin/bash

set -x verbose
rm -rfv run

point2las ../data/ref-PC.tif --output-prefix run/run-LAS --t_srs '+proj=longlat +ellps=WGS84 +no_defs '

