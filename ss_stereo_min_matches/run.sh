#!/bin/bash

# parallel_stereo must refuse when both --min-matches and its backward-compat
# alias --min-num-ip are set, since they name the same option. See the
# --min-matches entry in the stereo documentation.
#
# Negative case: setting both is expected to fail; we record the exit status,
# and validate.sh checks it against gold.
# Positive control: setting only --min-matches must parse successfully.

set -x verbose
rm -rfv run
mkdir -p run

L1=../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.tif
R1=../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.tif
L2=../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.xml
R2=../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.xml

# Negative case: both options set.
stereo_parse $L1 $R1 $L2 $R2 run/neg -t dg --min-matches 10 --min-num-ip 10
echo $? > run/neg_status.txt

# Positive control: only --min-matches set.
stereo_parse $L1 $R1 $L2 $R2 run/pos -t dg --min-matches 10
echo $? > run/pos_status.txt
