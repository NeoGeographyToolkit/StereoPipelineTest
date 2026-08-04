#!/bin/bash

set -x verbose
rm -rfv run

# Old-style (non-namespaced) DigitalGlobe/WorldView XML.
wv_correct ../data/WV02_10OCT091530189-P1BS-1030010007898D00_crop.tif ../data/WV02_10OCT091530189-P1BS-1030010007898D00.xml run/run.tif

# New-style Vantor/Maxar namespaced XML (lv1b:/isdc: prefixes). Same image, so
# the corrected output must be identical to the run above. This is the sanity
# check that the XML namespace format change does not alter the result.
wv_correct ../data/WV02_10OCT091530189-P1BS-1030010007898D00_crop.tif ../data/WV02_10OCT091530189-P1BS-1030010007898D00_maxar_ns.xml run/run_maxar_ns.tif

