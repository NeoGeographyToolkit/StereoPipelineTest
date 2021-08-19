#!/bin/bash

set -x verbose
rm -rfv run

# Run ipfind and ipmatch for the most used methods

for method in obalog sift orb; do
    
    desc=$method
    if [ "$method" = "obalog" ]; then
        desc="sgrad"
    fi
    
    ipfind --ip-per-tile 2000 --interest-operator $method --descriptor-generator $desc ../data/left_sub16.tif ../data/right_sub16.tif --output-folder run/${method}
    
    distance_metric="l2"
    if [ "$method" = "orb" ]; then
        distance_metric="hamming"
    fi
    
    ipmatch --distance-metric $distance_metric ../data/left_sub16.tif run/${method}/left_sub16.vwip ../data/right_sub16.tif run/${method}/right_sub16.vwip -o run/${method}/run
    
    # Convert the matches to txt and vice-versa
    $ISISROOT/bin/python $(which parse_match_file.py) run/${method}/run-left_sub16__right_sub16.match run/${method}/matches.txt
    $ISISROOT/bin/python $(which parse_match_file.py) -rev run/${method}/matches.txt run/${method}/run-left_sub16__right_sub16_v2.match

    # Ensure that this tool can read the match file it just created
    $ISISROOT/bin/python $(which parse_match_file.py) run/${method}/run-left_sub16__right_sub16_v2.match run/${method}/matches_v2.txt

done
