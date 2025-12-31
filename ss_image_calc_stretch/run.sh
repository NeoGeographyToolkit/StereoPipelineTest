#!/bin/bash

set -x verbose
rm -rfv run

image_calc --stretch ../data/zone10-CA_SanLuisResevoir-9m_10pct.tif -o run/run.tif

