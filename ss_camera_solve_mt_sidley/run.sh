#!/bin/bash

set -x verbose

# Not sure why sometimes it fails. This is a temporary hack, just try again.
for ((i=0; i<=10;i++)); do 

  rm -rfv run

  camera_solve run/solve ../data/mt_sidley_47.tif ../data/mt_sidley_48.tif --calib-file camera_info.tsai  --gcp-file ground_control_points.gcp --theia-retries 10 --reuse-theia-matches

  stereo ../data/mt_sidley_47.tif ../data/mt_sidley_48.tif run/solve/mt_sidley_47.tif.final.tsai run/solve/mt_sidley_48.tif.final.tsai run/run --left-image-crop-win 1891 6034 690 345  --right-image-crop-win 4750 5889 708 369

  point2dem run/run-PC.tif

  if [ -f run/run-DEM.tif ]; then 
	  break
  fi
  sleep 60
done

