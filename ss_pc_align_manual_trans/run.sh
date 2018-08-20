#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/pluto-dem1.tif ../data/pluto-dem2.tif --match-file ../data/pluto1-pluto2.match --max-displacement -1



