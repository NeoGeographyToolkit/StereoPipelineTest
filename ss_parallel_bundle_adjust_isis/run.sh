#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

echo localhost > run/machines.txt

parallel_bundle_adjust --processes 1 --threads 1 --nodes-list run/machines.txt  ../data/M0100115_small.cub ../data/E0201461_small.cub -o run/run --num-iterations 5 --ip-per-tile 1000

# Test creating an ISIS cnet
bundle_adjust --threads 1 ../data/M0100115_small.cub ../data/E0201461_small.cub -o run/run-cnet --num-iterations 5 --ip-per-tile 1000 --match-files-prefix run/run --output-cnet-type isis-cnet

# Test running jigsaw
ls ../data/M0100115_small.cub ../data/E0201461_small.cub > run/list.txt
jigsaw fromlist=run/list.txt update=no twist=no radius=yes cnet=run/run-cnet.net onet=run/run-jigsaw.net file_prefix=run/run

# Test reading an ISIS cnet
bundle_adjust --threads 1 ../data/M0100115_small.cub ../data/E0201461_small.cub -o run/run-cnet2 --num-iterations 5 --ip-per-tile 1000 --isis-cnet run/run-jigsaw.net

