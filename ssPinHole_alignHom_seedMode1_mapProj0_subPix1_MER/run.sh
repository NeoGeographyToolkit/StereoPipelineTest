#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/1m163693341eff5000p2956m2f1.img ../data/1m163693440eff5000p2956m2f1.img ../data/1m163693341eff5000p2956m2f1.cahvor ../data/1m163693440eff5000p2956m2f1.cahvor run/run

point2dem -r Earth run/run-PC.tif --nodata-value -32767 --remove-outliers

