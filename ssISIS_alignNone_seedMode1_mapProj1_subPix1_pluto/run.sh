#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/lor_0299174857_0x630_sci.mapmatch.cub ../data/lor_0299178899_0x630_sci.map.cub run/run --alignment-method none --left-image-crop-win 522 729 498 529 --right-image-crop-win 549 725 444 491                 
point2dem --t_srs '+proj=eqc +lat_ts=24.842164080061 +lat_0=0 +lon_0=169.26644220682 +x_0=0 +y_0=0 +a=1187000 +b=1187000 +units=m +no_defs ' --nodata-value -1000000000000 --tr 800  run/run-PC.tif




