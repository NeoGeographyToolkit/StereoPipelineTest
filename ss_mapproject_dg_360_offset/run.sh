#!/bin/bash

set -x verbose
rm -rfv run

mapproject ../data/filled_dem.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml run/run.tif

