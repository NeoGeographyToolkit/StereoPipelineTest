#!/bin/bash

# Tests bathy_threshold_calc.py: the KDE-histogram water-land threshold from a
# NIR (band 7) image. Split out of ssDG_alignAffEpp_seedMode1_mapProj0_bathy so
# that the bathy stereo test does not depend on the extra 'bathy' Python env.
#
# Needs ~oalexan1/miniconda3/envs/bathy (scipy/sklearn for the KDE). Not a cloud
# test. validate.sh compares the suggested threshold with a relative tolerance,
# since the KDE minimum can shift a little across Python module versions.
# Input: ../data/left_bathy_b7.tif. Gold: gold/run-threshold.txt.
