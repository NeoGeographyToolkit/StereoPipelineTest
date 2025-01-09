#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/1m163693341eff5000p2956m2f1.img ../data/1m163693440eff5000p2956m2f1.img ../data/1m163693341eff5000p2956m2f1.cahvor ../data/1m163693440eff5000p2956m2f1.cahvor run/run

point2dem --nodata-value -32767 --semi-major-axis 1 --semi-minor-axis 1 run/run-PC.tif

