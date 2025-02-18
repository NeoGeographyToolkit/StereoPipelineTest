#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/zone10-CA_SanLuisResevoir-9m_sub5-PC.tif ../data/zone10-CA_SanLuisResevoir-9m_sub5-PC_shift50_angle0.01.tif --save-transformed-source-points --output-prefix run/run --max-displacement 1000 --datum WGS_1984

