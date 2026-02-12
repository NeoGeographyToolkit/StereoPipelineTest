set -x verbose
rm -rfv run

# Test --ip-filter-using-dem
stereo --dem ../data/zone10-CA_SanLuisResevoir-9m.tif --corr-timeout 6000 ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_rpc_5mpp.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_rpc_5mpp.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_rpc.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_rpc.xml run/run --corr-max-levels 5 -t rpcmaprpc -s stereo.default --alignment-method none --subpixel-mode 1 --disable-fill-holes --threads 32 --subpixel-h-kernel 19 --subpixel-v-kernel 19 --corr-seed-mode 1 --left-image-crop-win 1024 1024 1024 2048 --ip-filter-using-dem "../data/filled_dem.tif 50"

point2dem -r Earth run/run-PC.tif --nodata-value -32767

