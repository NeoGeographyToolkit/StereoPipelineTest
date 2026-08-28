#!/bin/bash
source ../bin/setup_env.sh

# Compare the DEM and the propagated stddev rasters (bathymetry bends the rays in
# the covariance, so the vertical stddev grows under water).
for file in run/run-DEM.tif run/run-HorizontalStdDev.tif run/run-VerticalStdDev.tif; do
    gold=gold/$(basename $file)

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi

    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi

    # Remove cached xmls
    rm -fv "$file.aux.xml"
    rm -fv "$gold.aux.xml"

    cmp_stats.sh $file $gold
    gdalinfo -stats $file | grep -v Files | grep -v -i tif > run/run.txt
    gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold/run.txt

    diff=$(diff run/run.txt gold/run.txt)
    cat run/run.txt
    rm -f run/run.txt gold/run.txt

    echo "$file diff is $diff"
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi
done

# Also validate the interest point matches extracted from the disparity with
# --num-matches-from-disparity. These exercise the crop-window code path (the
# matches are shifted from the cropped domain to full-image coordinates). The
# match file is deterministic, so compare it directly.
mfile=run/run-disp-img_icebridge2__img_icebridge3.txt
mgold=gold/$(basename $mfile)

if [ ! -e "$mfile" ]; then
    echo "ERROR: File $mfile does not exist."
    exit 1;
fi

if [ ! -e "$mgold" ]; then
    echo "ERROR: File $mgold does not exist."
    exit 1;
fi

mdiff=$(diff $mfile $mgold)
echo match diff is $mdiff
if [ "$mdiff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
