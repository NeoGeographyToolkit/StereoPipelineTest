bundle_adjust ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.photometrix.tsai ../data/right_sub16.photometrix.tsai --create-pinhole-cameras -t pinhole --datum WGS84 -o run/run --ip-per-tile 1000 --fixed-camera-indices "1" --threads 1
