#!/bin/bash
export PATH=../bin:$PATH

# List of files to validate
FILES="run/run-DEM.tif run/run-tiles.shp run/run-tiles.qml"

for file in $FILES; do
    gold=gold/$(basename $file)

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1
    fi

    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1
    fi

    # Logic for GeoTIFFs (using gdalinfo/diff)
    if [[ "$file" == *.tif ]]; then
        rm -fv "$file.aux.xml"
        rm -fv "$gold.aux.xml"

        cmp_stats.sh "$file" "$gold"
        gdalinfo -stats "$file" | grep -v Files | grep -v -i tif > run/run.txt
        gdalinfo -stats "$gold" | grep -v Files | grep -v -i tif > gold/run.txt

        diff=$(diff run/run.txt gold/run.txt)
        if [ "$diff" != "" ]; then
            echo "diff is $diff"
            echo "Validation failed for $file"
            exit 1
        fi

    # Logic for SHP and QML (using cmp)
    else
        echo "Comparing $file and $gold using cmp"
        if ! cmp -s "$file" "$gold"; then
            echo "ERROR: Binary/Exact match validation failed for $file"
            exit 1
        fi
    fi
done

echo "Validation succeeded"
exit 0
