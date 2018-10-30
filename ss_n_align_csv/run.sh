#!/bin/bash

set -x verbose
rm -rfv run

n_align --num-iterations 10 --datum WGS84 --align-to-first-cloud --csv-format '1:x 2:y 3:z' --save-transformed-clouds ../data/cloud0.txt ../data/cloud1.txt ../data/cloud2.txt -o run/run


