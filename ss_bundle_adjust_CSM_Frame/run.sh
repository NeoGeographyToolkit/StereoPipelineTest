#!/bin/bash

# I could not find so far a Dawn testcase which works with CSM because of spice issues.
# For now using a fake one.

set -x verbose
rm -rfv run

rm -fv transform.txt
echo "0.99999  0.004472124774634615 0   10" >> transform.txt 
echo "-0.004472124774634615 0.99999 0   20" >> transform.txt
echo "0        0       1   40             " >> transform.txt
echo "0        0       0   1              " >> transform.txt

bundle_adjust ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.json ../data/right_sub16.json --apply-initial-transform-only --initial-transform transform.txt

