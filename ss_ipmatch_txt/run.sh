#!/bin/bash

set -x verbose
rm -rfv run

# Run ipfind and ipmatch for the most used methods

for method in obalog; do
    
    desc=$method
    if [ "$method" = "obalog" ] || [ "$method" = "log" ]; then 
        desc="sgrad"
    fi
    
    ipfind --ip-per-tile 2000 --interest-operator $method --descriptor-generator $desc ../data/left_sub16.tif ../data/right_sub16.tif --output-folder run/${method}
    
    distance_metric="l2"
    if [ "$method" = "orb" ]; then
        distance_metric="hamming"
    fi
    
    ipmatch --matches-as-txt --distance-metric $distance_metric ../data/left_sub16.tif run/${method}/left_sub16.vwip ../data/right_sub16.tif run/${method}/right_sub16.vwip -o run/${method}/run
done
