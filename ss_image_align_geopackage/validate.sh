#!/bin/bash
source ../bin/setup_env.sh

# Validate the GeoPackage of interest point matches written by
# --match-points-geopackage. A GeoPackage is a SQLite file with an embedded
# timestamp, so a binary comparison of two .gpkg files is not reliable. Instead,
# dump both the run and gold GeoPackages to CSV with ogr2ogr (a deterministic
# text form) and compare the numeric values with a tolerance.

run_gpkg=run/matches.gpkg
gold_gpkg=gold/matches.gpkg

for f in "$run_gpkg" "$gold_gpkg"; do
  if [ ! -e "$f" ]; then
    echo "ERROR: File $f does not exist."
    exit 1
  fi
done

# Dump both GeoPackages to CSV
rm -fv run/matches.csv gold/matches.csv
ogr2ogr -f CSV run/matches.csv "$run_gpkg"
ogr2ogr -f CSV gold/matches.csv "$gold_gpkg"

# Show the textual difference, then judge with a relative tolerance
diff run/matches.csv gold/matches.csv

../bin/max_err.pl run/matches.csv gold/matches.csv # print the error
ans=$(../bin/max_err.pl run/matches.csv gold/matches.csv 1e-6) # compare the error
if [ "$ans" -eq 0 ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
