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

bundle_adjust --apply-initial-transform-only --initial-transform transform.txt ../data/LSZ_01636_1CD_XKU_09N120_S1.8bit.cub ../data/LSZ_02330_1CD_XKU_00S120_S1.8bit.cub ../data/LSZ_01636_1CD_XKU_09N120_S1.8bit.state.json ../data/LSZ_02330_1CD_XKU_00S120_S1.8bit.state.json -o run/run

