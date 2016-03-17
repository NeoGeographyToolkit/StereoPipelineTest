#!/bin/bash

set -x verbose
rm -rfv run

# Here's how the reference cloud was created from the source cloud in Matlab:
# A=load('src.csv'); A=A(:, 1:3);
# h=2; t=0.2; s=1.04; R=[cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1]; P=s*(R*A(:, 1:3)')'+h; save('src.csv', '-ascii', '-double', 'A'); save('ref.csv', '-ascii', '-double', 'P');

pc_align --csv-format '1:x 2:y 3:z' --max-displacement -1 --datum WGS_1984 --alignment-method similarity-point-to-point ../data/ref_cloud.csv ../data/src_cloud.csv --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --max-num-source-points 5000000 --max-num-reference-points 1000000000
