set -x verbose
rm -rfv run

# Test parallel_stereo
parallel_stereo                                                     \
  --corr-timeout 6000                                               \
  --alignment-method none                                           \
  --subpixel-mode 1                                                 \
  --corr-seed-mode 1                                                \
  --left-image-crop-win 0 0 1000 1000                               \
  --right-image-crop-win 0 0 1000 1000                              \
  --job-size-w 550                                                  \
  --job-size-h 550                                                  \
  --max-disp-spread 10                                              \
  ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_rpc_5mpp.tif \
  ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_rpc_5mpp.tif \
  ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_rpc.xml      \
  ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_rpc.xml      \
  run/run                                                           \
  ../data/zone10-CA_SanLuisResevoir-9m.tif

point2dem -r Earth run/run-PC.tif --nodata-value -32767

