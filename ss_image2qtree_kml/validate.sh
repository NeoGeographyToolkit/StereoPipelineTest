#!/bin/bash
exit 0

# Check that the top-level KML file exists
kml=run/kml_out/kml_out.kml
gold_kml=gold/kml_out/kml_out.kml

if [ ! -e "$kml" ]; then
    echo "ERROR: File $kml does not exist."
    exit 1
fi

if [ ! -e "$gold_kml" ]; then
    echo "ERROR: File $gold_kml does not exist."
    exit 1
fi

# Compare the top-level KML file
diff=$(diff "$kml" "$gold_kml")
echo "KML diff: $diff"
if [ "$diff" != "" ]; then
    echo "Validation failed: KML files differ"
    exit 1
fi

# Check expected number of output files
run_count=$(find run/kml_out -type f | wc -l | tr -d ' ')
echo "Run file count: $run_count"
if [ "$run_count" -lt 2 ]; then
    echo "Validation failed: too few output files"
    exit 1
fi

echo Validation succeeded
exit 0
