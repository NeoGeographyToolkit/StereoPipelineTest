#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo ../data/NLB_450492490EDR_F0310634NCAM00357M1.cub ../data/NRB_450492490EDR_F0310634NCAM00357M1.cub ../data/NLB_450492490EDR_F0310634NCAM00357M1.json ../data/NRB_450492490EDR_F0310634NCAM00357M1.json run/run
point2dem run/run-PC.tif

