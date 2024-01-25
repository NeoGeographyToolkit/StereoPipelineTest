#!/bin/bash

set -x verbose
rm -rfv run

# Test applying an adjustment and exporting a CSM model
cam_gen --camera-type linescan ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001.tif --input-camera ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001.xml --bundle-adjust-prefix ../data/run -o run/run.json

