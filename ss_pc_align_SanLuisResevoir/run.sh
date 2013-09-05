#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

pc_align $d/zone10-CA_SanLuisResevoir-9m_sub5-PC.tif $d/zone10-CA_SanLuisResevoir-9m_sub5-PC_shift50_angle0.01.tif --save-transformed-source-points --output-prefix run/run --max-displacement -1







