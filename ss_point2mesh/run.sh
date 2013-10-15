#!/bin/bash

set -x verbose
rm -rfv run

point2mesh ../data/zone10-CA_SanLuisResevoir-9m_sub5-PC.tif --output-prefix run/run


