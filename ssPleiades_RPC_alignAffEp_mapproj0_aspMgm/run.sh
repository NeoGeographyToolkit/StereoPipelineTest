#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --corr-tile-size 5000 --stereo-algorithm asp_mgm ../data/IMG_PHR1B_P_202204132246314_SEN_6304928201-1_R1C1_crop.TIF ../data/IMG_PHR1B_P_202204132247161_SEN_6304929201-1_R1C1_crop.tif ../data/RPC_PHR1B_P_202204132246314_SEN_6304928201-1.XML ../data/RPC_PHR1B_P_202204132247161_SEN_6304929201-1.XML run/run

point2dem --stereographic --proj-lon 0 --proj-lat 90 --errorimage run/run-PC.tif

